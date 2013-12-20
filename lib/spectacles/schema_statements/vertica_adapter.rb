require 'spectacles/schema_statements/abstract_adapter'

module Spectacles
  module SchemaStatements
    module VerticaAdapter
      include Spectacles::SchemaStatements::AbstractAdapter
      
      def views(name = nil)
        q = <<-SQL
          SELECT table_name FROM v_catalog.views
        SQL
        
        execute(q, name).map { |row| row['table_name'] }
      end

      def view_build_query(view, name = nil)
        q = <<-SQL
          SELECT view_definition FROM v_catalog.views WHERE table_name = '#{view}'
        SQL
        
        select_value(q, name) or raise "No view called #{view} found"
      end
    end
  end
end
