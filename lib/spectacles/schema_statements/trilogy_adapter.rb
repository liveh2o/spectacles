require "spectacles/schema_statements/mysql2_adapter"

module Spectacles
  module SchemaStatements
    # Trilogy is the default MySQL adapter for new Rails 8 apps. Its results
    # have the same shape as Mysql2 results, so it uses the same statements.
    module TrilogyAdapter
      include Spectacles::SchemaStatements::Mysql2Adapter
    end
  end
end
