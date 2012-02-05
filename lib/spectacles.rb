require 'active_record'
require 'spectacles/schema_statements'
require 'spectacles/version'

ActiveRecord::ConnectionAdapters::AbstractAdapter.class_eval do 
  include Spectacles::SchemaStatements
end

ActiveRecord::ConnectionAdapters::SQLiteAdapter.class_eval do 
  include Spectacles::SchemaStatements::SQliteAdapter
end
