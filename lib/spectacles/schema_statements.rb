require 'spectacles/schema_statements/abstract_adapter'

module Spectacles
  SUPPORTED_ADAPTERS = %w( Mysql Mysql2 PostgreSQL SQLServer SQLite )

  def self.load_adapters
    SUPPORTED_ADAPTERS.each do |db|
      adapter_class = "#{db}Adapter"

      if ActiveRecord::ConnectionAdapters.const_defined?(adapter_class)
        require "spectacles/schema_statements/#{db.downcase}_adapter"
        ActiveRecord::ConnectionAdapters.const_get(adapter_class).class_eval do
          include Spectacles::SchemaStatements.const_get(adapter_class) 
        end
      end
    end
  end
end
