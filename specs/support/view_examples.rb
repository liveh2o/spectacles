shared_examples_for "a view model" do
  ActiveRecord::Base.connection.create_view(:new_product_users) do
    "SELECT name AS product_name, first_name AS username FROM
    products JOIN users ON users.id = products.user_id"
  end

  class NewProductUser < Spectacles::View
    scope :duck_lovers, lambda { where(:product_name => 'Rubber Duck') }
  end

  describe "Spectacles::View" do
    describe "inherited class" do
      it "can has scopes" do
        User.destroy_all
        Product.destroy_all
        @john = User.create(:first_name => 'John', :last_name => 'Doe')
        @john.products.create(:name => 'Rubber Duck', :value => 10)

        _(NewProductUser.duck_lovers.load.first.username).must_be @john.first_name
      end

      describe "an instance" do
        it "is readonly" do
          _(NewProductUser.new.readonly?).must_be true
        end
      end
    end
  end

  if ActiveRecord::Base.connection.supports_materialized_views?
    ActiveRecord::Base.connection.create_materialized_view(:materialized_product_users) do
      "SELECT name AS product_name, first_name AS username FROM
      products JOIN users ON users.id = products.user_id"
    end

    class MaterializedProductUser < Spectacles::MaterializedView
      scope :duck_lovers, lambda { where(:product_name => 'Rubber Duck') }
    end

    describe "Spectacles::MaterializedView" do
      before(:each) do
        User.delete_all
        Product.delete_all
        @john = User.create(:first_name => 'John', :last_name => 'Doe')
        @duck = @john.products.create(:name => 'Rubber Duck', :value => 10)
        MaterializedProductUser.refresh!
      end

      it "can has scopes" do
        _(MaterializedProductUser.duck_lovers.load.first.username).must_be @john.first_name
      end

      it "is readonly" do
        _(MaterializedProductUser.first.readonly?).must_be true
      end
    end
  end
end
