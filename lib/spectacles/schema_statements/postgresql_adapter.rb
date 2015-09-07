require 'spectacles/schema_statements/abstract_adapter'

module Spectacles
  module SchemaStatements
    module PostgreSQLAdapter
      include Spectacles::SchemaStatements::AbstractAdapter

      def views(name = nil) #:nodoc:
        q = <<-SQL
        SELECT table_name, table_type
          FROM information_schema.tables
         WHERE table_schema = ANY(current_schemas(false))
           AND table_type = 'VIEW'
        SQL

        execute(q, name).map { |row| row['table_name'] }
      end

      def view_build_query(view, name = nil)
        q = <<-SQL
        SELECT view_definition
          FROM information_schema.views
         WHERE table_catalog = (SELECT catalog_name FROM information_schema.information_schema_catalog_name)
           AND table_schema = ANY(current_schemas(false))
           AND table_name = '#{view}'
        SQL

        view_sql = select_value(q, name) or raise "No view called #{view} found"
        view_sql.gsub("\"", "\\\"")
      end

      def supports_materialized_views?
        true
      end

      def materialized_views(name = nil)
        query = <<-SQL.squish
          SELECT relname
            FROM pg_class
           WHERE relnamespace IN (
                    SELECT oid
                      FROM pg_namespace
                     WHERE nspname = ANY(current_schemas(false)))
             AND relkind = 'm';
        SQL

        execute(query, name).map { |row| row['relname'] }
      end

      # Returns a tuple [string, hash], where string is the query used
      # to construct the view, and hash contains the options given when
      # the view was created.
      def materialized_view_build_query(view, name = nil)
        storage = select_value("SELECT reloptions FROM pg_class WHERE relname=#{quote(view)}", name)
        rows = execute("SELECT tablespace, ispopulated, definition FROM pg_matviews WHERE matviewname=#{quote(view)}", name);

        tablespace = rows[0]["tablespace"]
        ispopulated = rows[0]["ispopulated"]
        definition = rows[0]["definition"].strip.sub(/;$/, "")

        options = {}
        options[:data] = false if ispopulated == 'f'
        options[:storage] = parse_storage_definition(storage) if storage.present?
        options[:tablespace] = tablespace if tablespace.present?

        [definition, options]
      end

      def create_materialized_view_statement(view_name, query, options={})
        columns = if options[:columns]
            "(" + options[:columns].map { |c| quote_column_name(c) }.join(",") + ")"
          else
            ""
          end

        storage = if options[:storage] && options[:storage].any?
            "WITH (" + options[:storage].map { |key, value| "#{key}=#{value}" }.join(", ") + ")"
          else
            ""
          end

        tablespace = if options[:tablespace]
            "TABLESPACE #{quote_table_name(options[:tablespace])}"
          else
            ""
          end

        with_data = if options.fetch(:data, true)
            "WITH DATA"
          else
            "WITH NO DATA"
          end

        <<-SQL.squish
          CREATE MATERIALIZED VIEW #{quote_table_name(view_name)}
            #{columns}
            #{storage}
            #{tablespace}
            AS #{query}
            #{with_data}
        SQL
      end

      def create_materialized_view(view_name, *args)
        options = args.extract_options!
        build_query = args.shift

        raise "#create_materialized_view requires a query or block" if build_query.nil? && !block_given?

        build_query = yield if block_given?
        build_query = build_query.to_sql if build_query.respond_to?(:to_sql)

        if options[:force] && materialized_view_exists?(view_name)
          drop_materialized_view(view_name)
        end

        query = create_materialized_view_statement(view_name, build_query, options)
        execute(query)
      end

      def drop_materialized_view(view_name)
        execute "DROP MATERIALIZED VIEW IF EXISTS #{quote_table_name(view_name)}"
      end

      def refresh_materialized_view(view_name)
        execute "REFRESH MATERIALIZED VIEW #{quote_table_name(view_name)}"
      end

      def parse_storage_definition(storage)
        storage = storage.gsub(/^{|}$/, "")
        storage.split(/,/).inject({}) do |hash, item|
          key, value = item.strip.split(/=/)
          hash[key.to_sym] = value
          hash
        end
      end
    end
  end
end
