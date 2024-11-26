module Spectacles
  class MaterializedView < ActiveRecord::Base
    self.abstract_class = true

    def self.new(*)
      raise NotImplementedError, "#{self} is an abstract class and cannot be instantiated."
    end

    def self.materialized_view_exists?
      connection.materialized_view_exists?(view_name)
    end

    def self.refresh!(concurrently: false)
      if concurrently
        connection.refresh_materialized_view_concurrently(view_name)
      else
        connection.refresh_materialized_view(view_name)
      end
    end

    def self.refresh_concurrently!
      refresh!(concurrently: true)
    end

    class << self
      alias_method :table_exists?, :materialized_view_exists?
      alias_method :view_name, :table_name
    end

    def ==(other)
      super ||
        other.instance_of?(self.class) &&
          attributes.present? &&
          other.attributes == attributes
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
