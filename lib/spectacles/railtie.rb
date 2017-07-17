require 'spectacles'
require 'rails'

module Spectacles
  class Railtie < ::Rails::Railtie
    config.spectacles = ::ActiveSupport::OrderedOptions.new

    initializer 'spectacles.configure' do |app|
      Spectacles.configure do |config|
        if app.config.spectacles.key?(:enable_schema_dump)
          config.enable_schema_dump = app.config.spectacles[:enable_schema_dump]
        end
        if app.config.spectacles.key?(:skip_views)
          config.skip_views = app.config.spectacles[:skip_views]
        end
      end
    end
  end
end
