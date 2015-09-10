require 'spectacles/schema_statements/abstract_adapter'
require 'spectacles/schema_statements/mysql_backports'

module Spectacles
  module SchemaStatements
    module MysqlAdapter
      include Spectacles::SchemaStatements::AbstractAdapter
      include Spectacles::SchemaStatements::MysqlBackports

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
