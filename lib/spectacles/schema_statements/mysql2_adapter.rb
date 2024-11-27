module Spectacles
  module SchemaStatements
    module Mysql2Adapter
      include Spectacles::SchemaStatements::AbstractAdapter

      def views(name = nil) # :nodoc:
        result = execute("SHOW FULL TABLES WHERE TABLE_TYPE='VIEW'")

        rows_from(result).map(&:first)
      end

      def view_build_query(view, name = nil)
        result = execute("SHOW CREATE VIEW #{view}", name)
        algorithm_string = rows_from(result).first[1]

        algorithm_string.gsub(/CREATE .*? (AS)+/i, "")
      rescue ActiveRecord::StatementInvalid => e
        raise "No view called #{view} found, #{e}"
      end

      private

      def rows_from(result)
        result.respond_to?(:rows) ? result.rows : result
      end
    end
  end
end
