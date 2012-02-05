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

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "specs/test.db"
)

class User < ActiveRecord::Base
  has_many :products
end

class Product < ActiveRecord::Base
  belongs_to :user
end

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
