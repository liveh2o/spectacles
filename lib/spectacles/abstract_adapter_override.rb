ActiveRecord::ConnectionAdapters::AbstractAdapter.class_eval do
  alias_method(:_spectacles_original_inherited, :inherited) if method_defined?(:inherited)

  def self.inherited(klass)
    ::Spectacles::load_adapters
    _spectacles_orig_inherited if method_defined?(:_spectacles_original_inherited)
  end
end
