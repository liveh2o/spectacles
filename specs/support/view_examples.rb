require 'spec_helper'

shared_examples_for "a view model" do
  ActiveRecord::Base.connection.create_view(:new_product_users) do
    "SELECT name AS product_name, first_name AS username FROM
    products JOIN users ON users.id = products.user_id"
  end

  class NewProductUser < Spectacles::View
    scope :duck_lovers, where(:product_name => 'Rubber Duck')
  end

  describe "Spectacles::View" do
    describe "inherited class" do
      it "can has scopes" do
        User.destroy_all
        Product.destroy_all
        @john = User.create(:first_name => 'John', :last_name => 'Doe')
        @john.products.create(:name => 'Rubber Duck', :value => 10)

        NewProductUser.duck_lovers.load.first.username.must_be @john.first_name
      end

      describe "an instance" do
        it "is readonly" do
          NewProductUser.new.readonly?.must_be true
        end
      end
    end
  end
end
