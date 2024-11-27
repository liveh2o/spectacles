class User < ActiveRecord::Base
  has_many :products
end

class Product < ActiveRecord::Base
  belongs_to :user
end

class NewProductUser < Spectacles::View
  scope :duck_lovers, lambda { where(product_name: "Rubber Duck") }
end

class TestBase
  extend Spectacles::SchemaStatements::AbstractAdapter

  def self.materialized_views
    @materialized_views ||= nil
    @materialized_views || super
  end

  def self.with_materialized_views(list)
    @materialized_views = list
    yield
  ensure
    @materialized_views = nil
  end
end
