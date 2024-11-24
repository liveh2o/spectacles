require 'spectacles/schema_statements/abstract_adapter'

module Spectacles
  SUPPORTED_ADAPTERS = %w( Mysql2 PostgreSQL SQLServer SQLite SQLite3 Vertica )

  def self.load_adapters
    SUPPORTED_ADAPTERS.each do |db|
      adapter_class = "#{db}Adapter"

      if ActiveRecord::ConnectionAdapters.const_defined?(adapter_class)
        require "spectacles/schema_statements/#{db.downcase}_adapter"

        adapter = ActiveRecord::ConnectionAdapters.const_get(adapter_class)
        extension = Spectacles::SchemaStatements.const_get(adapter_class)

        adapter.send :prepend, extension
      end
    end
  end
end
