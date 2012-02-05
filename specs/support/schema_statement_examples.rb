require 'spec_helper'

shared_examples_for "an adapter" do |adapter|
  SharedBase = Class.new do
    extend Spectacles::SchemaStatements.const_get(adapter)
    def self.execute(query); query; end 
  end

  describe "ActiveRecord::SchemaDumper#dump" do 
    before(:each) do
      ActiveRecord::Base.connection.drop_view(:new_product_users)

      ActiveRecord::Base.connection.create_view(:new_product_users) do 
        "SELECT name AS product_name, first_name AS username FROM
        products JOIN users ON users.id = products.user_id"
      end
    end

    it "should return create_view in dump stream" do 
      stream = StringIO.new
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, stream)
      stream.string.must_match(/create_view/)
    end
  end

  describe "#create_view" do
    let(:view_name) { :view_name }

    it "throws error when block not given and no build_query" do 
      lambda { SharedBase.create_view(view_name) }.must_raise(RuntimeError)
    end

    describe "view_name" do
      it "takes a symbol as the view_name" do 
        SharedBase.create_view(view_name.to_sym, Product.scoped).must_match(/#{view_name}/)
      end

      it "takes a string as the view_name" do 
        SharedBase.create_view(view_name.to_s, Product.scoped).must_match(/#{view_name}/)
      end
    end

    describe "build_query" do 
      it "uses a string if passed" do 
        select_statement = "SELECT * FROM products"
        SharedBase.create_view(view_name, select_statement).must_match(/#{Regexp.escape(select_statement)}/)
      end

      it "uses an Arel::Relation if passed" do 
        select_statement = Product.scoped.to_sql
        SharedBase.create_view(view_name, Product.scoped).must_match(/#{Regexp.escape(select_statement)}/)
      end
    end

    describe "block" do 
      it "can use an Arel::Relation from the yield" do 
        select_statement = Product.scoped.to_sql
        SharedBase.create_view(view_name) { Product.scoped }.must_match(/#{Regexp.escape(select_statement)}/)
      end

      it "can use a String from the yield" do 
        select_statement = "SELECT * FROM products"
        SharedBase.create_view(view_name) { "SELECT * FROM products" }.must_match(/#{Regexp.escape(select_statement)}/)
      end
    end
  end

  describe "#drop_view" do
    let(:view_name) { :view_name }

    describe "view_name" do
      it "takes a symbol as the view_name" do 
        SharedBase.drop_view(view_name.to_sym).must_match(/#{view_name}/)
      end

      it "takes a string as the view_name" do 
        SharedBase.drop_view(view_name.to_s).must_match(/#{view_name}/)
      end
    end
  end
end