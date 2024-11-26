ActiveRecord::ConnectionAdapters::AbstractAdapter.class_eval do
  class << self
    alias_method(:_spectacles_orig_inherited, :inherited) if method_defined?(:inherited)

    def inherited(klass)
      ::Spectacles.load_adapters
      _spectacles_orig_inherited(klass) if methods.include?(:_spectacles_orig_inherited)
    end
  end
end
