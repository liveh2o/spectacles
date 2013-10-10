module Spectacles
  class View < ActiveRecord::Base
    self.abstract_class = true

    def self.view_exists?
      self.connection.view_exists?(self.view_name)
    end

    class << self
      alias_method :table_exists?, :view_exists?
      alias_method :view_name, :table_name
    end

    def ==(comparison_object)
      super ||
        comparison_object.instance_of?(self.class) &&
        attributes.present? &&
        comparison_object.attributes == attributes
    end

    def readonly?
      true
    end
  end

  ::ActiveSupport.run_load_hooks(:spectacles, View)
end
