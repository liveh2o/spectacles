module Spectacles
  class View < ActiveRecord::Base
    self.abstract_class = true

    def self.new(*)
      raise NotImplementedError, "#{self} is an abstract class and cannot be instantiated."
    end

    def self.view_exists?
      connection.view_exists?(view_name)
    end

    class << self
      alias_method :table_exists?, :view_exists?
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

  ::ActiveSupport.run_load_hooks(:spectacles, View)
end
