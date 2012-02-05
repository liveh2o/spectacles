require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler'
Bundler.require(:default, :development, :test)

require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'

File.delete(File.dirname(__FILE__) + "/test.db") rescue nil

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "specs/test.db"
)

ActiveRecord::Base.connection.tables.each do |table|
  ActiveRecord::Base.connection.drop_table(table)
end

ActiveRecord::Base.connection.views.each do |view|
  ActiveRecord::Base.connection.drop_view(view)
end

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

  create_view :new_product_users do 
    "SELECT name AS product_name, first_name AS username FROM products JOIN users ON users.id = products.user_id"
  end
end
