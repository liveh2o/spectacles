require 'active_record'
require 'spectacles/schema_statements'
require 'spectacles/version'

ActiveRecord::ConnectionAdapters::AbstractAdapter.class_eval do
  alias_method(:_spectacles_orig_inherited, :inherited) if method_defined?(:inherited)

  def self.inherited(klass)
    Spectacles::load_adapters
    _spectacles_orig_inherited if method_defined?(:_spectacles_orig_inherited)
  end
end

Spectacles::load_adapters
