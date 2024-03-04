require 'spectacles/schema_statements/abstract_adapter'

module Spectacles
  module SchemaStatements
    module PostgreSQLAdapter
      include Spectacles::SchemaStatements::AbstractAdapter

      def views(name = nil) #:nodoc:
        q = <<-SQL
              SELECT t.table_name
                FROM information_schema.views AS t
          INNER JOIN pg_class AS c ON c.relname = t.table_name AND c.relnamespace = to_regnamespace(t.table_schema)::oid
               WHERE t.table_schema = ANY(current_schemas(true))
                 AND pg_catalog.pg_get_userbyid(c.relowner) = #{quote(database_username)}
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
        result = execute <<-SQL.squish, name
          SELECT a.reloptions, b.tablespace, b.ispopulated, b.definition
            FROM pg_class a, pg_matviews b
           WHERE a.relname=#{quote(view)}
             AND b.matviewname=a.relname
        SQL
        row = result.to_a[0]

        storage = row["reloptions"]
        tablespace = row["tablespace"]
        ispopulated = row["ispopulated"]
        definition = row["definition"].strip.sub(/;$/, "")

        options = {}
        options[:data] = false if ispopulated == 'f' || ispopulated == false
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

      def refresh_materialized_view_concurrently(view_name)
        execute "REFRESH MATERIALIZED VIEW CONCURRENTLY #{quote_table_name(view_name)}"
      end

      def parse_storage_definition(storage)
        # JRuby 9000 returns storage as an Array, whereas
        # MRI returns a string.
        storage = storage.first if storage.is_a?(Array)

        storage = storage.gsub(/^{|}$/, "")
        storage.split(/,/).inject({}) do |hash, item|
          key, value = item.strip.split(/=/)
          hash[key.to_sym] = value
          hash
        end
      end

      def database_username
        @config[:username]
      end
    end
  end
end
