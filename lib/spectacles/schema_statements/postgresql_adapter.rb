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
    end
  end
end
