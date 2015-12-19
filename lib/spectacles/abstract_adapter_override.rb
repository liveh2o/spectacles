ActiveRecord::ConnectionAdapters::AbstractAdapter.class_eval do
  class << self
    alias_method(:_spectacles_orig_inherited, :inherited) if method_defined?(:inherited)

    def inherited(_subclass)
      ::Spectacles::load_adapters
      _spectacles_orig_inherited(_subclass) if methods.include?(:_spectacles_orig_inherited)
    end
  end
end
