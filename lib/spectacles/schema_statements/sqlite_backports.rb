module Spectacles
  module SchemaStatements
    module SqliteBackports

      # copied from ActiveRecord, because the sqlite3 adapter in AR
      # tries to return both tables AND views with this method.
      def tables_without_views(name = nil, table_name = nil) #:nodoc:
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

    end
  end
end
