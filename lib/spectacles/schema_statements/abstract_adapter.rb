module Spectacles
  
  module SchemaStatements

    module AbstractAdapter

      def create_view(view_name, build_query = nil)
        raise "#{self.class} requires a query or block" if build_query.nil? && !block_given?

        build_query = yield if block_given?
        build_query = build_query.to_sql if build_query.respond_to?(:to_sql)

        build_view(view_name, build_query)
      end

      def drop_view(view_name)
        query = "DROP VIEW IF EXISTS ?"
        query_array = [query, view_name.to_s]
        query = ActiveRecord::Base.__send__(:sanitize_sql_array, query_array)  
        execute(query)
      end

      def views
        raise "Override view for your db adapter in #{self.class}"
      end

    private

      def build_view(view_name, query)
        query = "CREATE VIEW ? AS #{query}"
        query_array = [query, view_name.to_s]
        query = ActiveRecord::Base.__send__(:sanitize_sql_array, query_array)  
        execute(query)
      end

    end

  end

end
