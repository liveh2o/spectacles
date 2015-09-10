require 'spectacles/schema_statements/abstract_adapter'
require 'spectacles/schema_statements/sqlite_backports'

module Spectacles
  module SchemaStatements
    module SQLite3Adapter
      include Spectacles::SchemaStatements::AbstractAdapter
      include Spectacles::SchemaStatements::SqliteBackports

      def generate_view_query(*columns)
        sql = <<-SQL
          SELECT #{columns.join(',')}
          FROM sqlite_master
          WHERE type = 'view'
        SQL
      end

      def views #:nodoc:
        sql = generate_view_query(:name)

        exec_query(sql, "SCHEMA").map do |row|
          row['name']
        end
      end

      def view_build_query(table_name)
        sql = generate_view_query(:sql)
        sql << " AND name = #{quote_table_name(table_name)}"

        row = exec_query(sql, "SCHEMA").first
        row['sql'].gsub(/CREATE VIEW .*? AS/i, "")
      end
    end
  end
end
