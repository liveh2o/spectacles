require "spectacles/schema_statements/abstract_adapter"

module Spectacles
  module SchemaStatements
    module SQLServerAdapter
      include Spectacles::SchemaStatements::AbstractAdapter

      def views(name = nil) # :nodoc:
        select_values("SELECT table_name FROM information_schema.views", name)
      end

      def view_build_query(view, name = nil)
        q = <<-ENDSQL
          SELECT view_definition FROM information_schema.views
          WHERE table_name = '#{view}'
        ENDSQL

        q = select_value(q, name) or raise "No view called #{view} found"
        q.gsub(/CREATE VIEW .*? AS/i, "")
      end
    end
  end
end
