# frozen_string_literal: true

require "active_record"
require "active_support/core_ext"
require "spectacles/schema_statements"
require "spectacles/schema_dumper"
require "spectacles/view"
require "spectacles/materialized_view"
require "spectacles/version"
require "spectacles/configuration"
require "spectacles/abstract_adapter_override"

require "spectacles/railtie" if defined?(Rails)

module Spectacles
  def self.configuration
    @configuration ||= ::Spectacles::Configuration.new
  end

  def self.configure
    yield(configuration) if block_given?
  end

  class << self
    alias_method :config, :configuration
  end
end

ActiveRecord::SchemaDumper.class_eval do
  alias_method(:_spectacles_orig_trailer, :trailer)

  def trailer(stream)
    ::Spectacles::SchemaDumper.dump_views(stream, @connection)
    ::Spectacles::SchemaDumper.dump_materialized_views(self, stream, @connection)
    _spectacles_orig_trailer(stream)
  end
end

Spectacles.load_adapters
