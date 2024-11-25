module Spectacles
  module SchemaStatements
    module AbstractAdapter
      def create_view(view_name, *args)
        options = args.extract_options!
        build_query = args.shift

        raise "#{self.class} requires a query or block" if build_query.nil? && !block_given?

        build_query = yield if block_given?
        build_query = build_query.to_sql if build_query.respond_to?(:to_sql)

        if options[:force] && view_exists?(view_name)
          drop_view(view_name)
        end

        query = create_view_statement(view_name, build_query)
        if defined?(ActiveRecord::Base.connection_handler) && ActiveRecord.respond_to?(:legacy_connection_handling) && ActiveRecord.legacy_connection_handling
          ActiveRecord::Base.connection_handler.while_preventing_writes(false) do
            execute(query)
          end
        else
          execute(query)
        end
      end

      def create_view_statement(view_name, create_query)
        # query = "CREATE VIEW ? AS #{create_query}"
        # query_array = [query, view_name.to_s]

        # return ActiveRecord::Base.__send__(:sanitize_sql_array, query_array)
        "CREATE VIEW #{view_name} AS #{create_query}"
      end

      def drop_view(view_name)
        query = drop_view_statement(view_name)
        execute(query)
      end

      def drop_view_statement(view_name)
        # query = "DROP VIEW IF EXISTS ? "
        # query_array = [query, view_name.to_s]

        # return ActiveRecord::Base.__send__(:sanitize_sql_array, query_array)
        "DROP VIEW IF EXISTS #{view_name} "
      end

      def view_exists?(name)
        views.include?(name.to_s)
      end

      def views
        raise "Override view for your db adapter in #{self.class}"
      end

      def supports_materialized_views?
        false
      end

      def materialized_view_exists?(name)
        materialized_views.include?(name.to_s)
      end

      def materialized_views
        raise NotImplementedError, "Override materialized_views for your db adapter in #{self.class}"
      end

      def materialized_view_build_query(view_name)
        raise NotImplementedError, "Override materialized_view_build_query for your db adapter in #{self.class}"
      end

      def create_materialized_view(view_name, *args)
        raise NotImplementedError, "Override create_materialized_view for your db adapter in #{self.class}"
      end

      def drop_materialized_view(view_name)
        raise NotImplementedError, "Override drop_materialized_view for your db adapter in #{self.class}"
      end

      def refresh_materialized_view(view_name)
        raise NotImplementedError, "Override refresh_materialized_view for your db adapter in #{self.class}"
      end

      def refresh_materialized_view_concurrently(view_name)
        raise NotImplementedError, "Override refresh_materialized_view_concurrently for your db adapter in #{self.class}"
      end
    end
  end
end
