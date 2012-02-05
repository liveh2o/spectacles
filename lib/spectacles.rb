require 'active_record'
require 'spectacles/schema_statements'
require 'spectacles/schema_statements/abstract_adapter'
require 'spectacles/version'

# TODO: check adapter type before loading
require 'spectacles/schema_statements/sqlite_adapter'
require 'active_record/connection_adapters/sqlite_adapter'

ActiveRecord::ConnectionAdapters::AbstractAdapter.class_eval do 
  include Spectacles::SchemaStatements::AbstractAdapter
end

ActiveRecord::ConnectionAdapters::SQLiteAdapter.class_eval do 
  include Spectacles::SchemaStatements::SQLiteAdapter
end
