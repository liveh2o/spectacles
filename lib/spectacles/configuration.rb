module Spectacles
  class Configuration
    attr_accessor :enable_schema_dump, :skip_views

    def initialize
      @enable_schema_dump = true
      @skip_views = []
    end
  end
end
