require 'spectacles/schema_statements/abstract_adapter'

module Spectacles
  module SchemaStatements
    module SQLite3Adapter
      include Spectacles::SchemaStatements::AbstractAdapter

      # overrides the #tables method from ActiveRecord's SQLite3Adapter
      # to return only tables, and not views.
      def tables(name = nil, table_name = nil)
        sql = <<-SQL
          SELECT name
          FROM sqlite_master
          WHERE type = 'table' AND NOT name = 'sqlite_sequence'
        SQL
        sql << " AND name = #{quote_table_name(table_name)}" if table_name

        exec_query(sql, 'SCHEMA').map do |row|
          row['name']
        end
      end

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
