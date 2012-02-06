require 'simplecov'
SimpleCov.start do 
  add_filter "/specs"
end

require 'rubygems'
require 'bundler'
Bundler.require(:default, :development, :test)

require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'
require 'support/minitest_shared'
require 'support/minitest_matchers'
require 'support/schema_statement_examples'

class User < ActiveRecord::Base
  has_many :products
end

class Product < ActiveRecord::Base
  belongs_to :user
end

ActiveRecord::Schema.verbose = false

def configure_database(config)
  @database_config = config
end

def load_schema
  ActiveRecord::Schema.define(:version => 1) do
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
    end

    create_table :products do |t|
      t.string :name
      t.integer :value
      t.boolean :available, :default => true
      t.belongs_to :user
    end
  end
end

def recreate_database(database)
  ActiveRecord::Base.establish_connection(@database_config)
  ActiveRecord::Base.connection.drop_database(database) rescue nil
  ActiveRecord::Base.connection.create_database(database)
  ActiveRecord::Base.establish_connection(@database_config.merge(:database => database))
end