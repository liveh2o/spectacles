module Spectacles
  
  module SchemaStatements
    
    module SQLiteAdapter
      
      def views(name = 'SCHEMA', table_name = nil) #:nodoc:
        sql = <<-SQL
          SELECT name
          FROM sqlite_master
          WHERE type = 'view'
        SQL
        sql << " AND name = #{quote_table_name(table_name)}" if table_name

        exec_query(sql, name).map do |row|
          row['name']
        end
      end
      
    end
    
  end
  
end
