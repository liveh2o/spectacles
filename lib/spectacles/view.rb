module Spectacles
  class View < ActiveRecord::Base
    self.abstract_class = true

    def readonly?
      true
    end
  end

  ::ActiveSupport.run_load_hooks(:spectacles, View)
end
