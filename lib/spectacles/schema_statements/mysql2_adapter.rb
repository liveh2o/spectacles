require 'spectacles/schema_statements/abstract_adapter'

module Spectacles
  module SchemaStatements
    module Mysql2Adapter
      include Spectacles::SchemaStatements::AbstractAdapter

      # overrides the #tables method from ActiveRecord's MysqlAdapter
      # to return only tables, and not views.
      def tables(name = nil, database = nil, like = nil)
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

      def views(name = nil) #:nodoc:
        execute("SHOW FULL TABLES WHERE TABLE_TYPE='VIEW'").map { |row| row[0] }
      end

      def view_build_query(view, name = nil)
        row = execute("SHOW CREATE VIEW #{view}", name).first
        return row[1].gsub(/CREATE .*? (AS)+/i, "")
      rescue ActiveRecord::StatementInvalid => e
        raise "No view called #{view} found"
      end
    end
  end
end
