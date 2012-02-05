require 'active_record'
require 'spectacles/schema_statements'
require 'spectacles/version'

ActiveRecord::ConnectionAdapters::AbstractAdapter.class_eval do
  def self.inherited(klass)
    Spectacles::load_adapters
  end
end

Spectacles::load_adapters
