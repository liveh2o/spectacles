module Spectacles
  class View < ActiveRecord::Base
    def readonly?
      true
    end
  end
end
