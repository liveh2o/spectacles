module Spectacles
  module SchemaStatements
    module Mysql2Adapter
      include Spectacles::SchemaStatements::AbstractAdapter

      def views(name = nil) # :nodoc:
        result = execute("SHOW FULL TABLES WHERE TABLE_TYPE='VIEW'")
        values_from(result).map(&:first)
      end

      def view_build_query(view, name = nil)
        result = execute("SHOW CREATE VIEW #{view}", name)
        algorithm_string = values_from(result).first[1]

        algorithm_string.gsub(/CREATE .*? (AS)+/i, "")
      rescue ActiveRecord::StatementInvalid => e
        raise "No view called #{view} found, #{e}"
      end

      private

      def values_from(result)
        result.first.respond_to?(:values) ? result.map(&:values) : result
      end
    end
  end
end
