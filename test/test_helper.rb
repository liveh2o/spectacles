# frozen_string_literal: true

require "simplecov"

SimpleCov.start do
  add_filter "/spec"
end

require "rubygems"
require "bundler"
Bundler.require(:default, :development, :test)

require "minitest/spec"
require "minitest/autorun"
require "minitest/pride"

require "support/minitest/shared_examples"
require "support/schema_statement_examples"
require "support/test_classes"
require "support/view_examples"

ActiveRecord::Schema.verbose = false

def configure_database(config)
  @database_config = config
end

def load_schema
  ActiveRecord::Schema.define(version: 1) do
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
    end

    create_table :products do |t|
      t.string :name
      t.integer :value
      t.boolean :available, default: true
      t.belongs_to :user
    end
  end
end

def recreate_database(database)
  ActiveRecord::Base.establish_connection(@database_config)
  begin
    ActiveRecord::Base.connection.drop_database(database)
  rescue
    nil
  end
  ActiveRecord::Base.connection.create_database(database)
  ActiveRecord::Base.establish_connection(@database_config.merge(database: database))
end
