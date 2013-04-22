module Spectacles
  class Configuration
    attr_accessor :enable_schema_dump

    def initialize
      @enable_schema_dump = true
    end
  end
end
