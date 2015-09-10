module Spectacles
  module SchemaStatements
    module MysqlBackports

      # Copied (and adapted) from ActiveRecord, because AR's
      # default implementation for mysql returns both tables
      # and views.
      def tables(name = nil, database = nil, like = nil) #:nodoc:
        database = database ? quote_table_name(database) : "DATABASE()"
        by_name  = like ? "AND table_name LIKE #{quote(like)}" : ""

        sql = <<-SQL.squish
          SELECT table_name, table_type
            FROM information_schema.tables
           WHERE table_schema = #{database}
             AND table_type = 'BASE TABLE'
             #{by_name}
        SQL

        execute_and_free(sql, 'SCHEMA') do |result|
          result.collect(&:first)
        end
      end

    end
  end
end
