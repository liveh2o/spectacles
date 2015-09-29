module Spectacles
  class MaterializedView < ActiveRecord::Base
    self.abstract_class = true

    def self.new(*)
      raise NotImplementedError
    end

    def self.materialized_view_exists?
      self.connection.materialized_view_exists?(self.view_name)
    end

    def self.refresh!
      self.connection.refresh_materialized_view(self.view_name)
    end

    class << self
      alias_method :table_exists?, :materialized_view_exists?
      alias_method :view_name, :table_name
    end

    def ==(comparison_object)
      super ||
        comparison_object.instance_of?(self.class) &&
        attributes.present? &&
        comparison_object.attributes == attributes
    end

    def persisted?
      false
    end

    def readonly?
      true
    end
  end

  ::ActiveSupport.run_load_hooks(:spectacles, MaterializedView)
end
