require 'active_record'
require 'active_support/core_ext'
require 'spectacles/schema_statements'
require 'spectacles/schema_dumper'
require 'spectacles/view'
require 'spectacles/version'

ActiveRecord::ConnectionAdapters::AbstractAdapter.class_eval do
  alias_method(:_spectacles_orig_inherited, :inherited) if method_defined?(:inherited)

  def self.inherited(klass)
    ::Spectacles::load_adapters
    _spectacles_orig_inherited if method_defined?(:_spectacles_orig_inherited)
  end
end

ActiveRecord::SchemaDumper.class_eval do 
  alias_method(:_spectacles_orig_trailer, :trailer) 

  def trailer(stream)
    ::Spectacles::SchemaDumper.dump_views(stream, @connection)
    _spectacles_orig_trailer(stream)
  end
end

Spectacles::load_adapters
