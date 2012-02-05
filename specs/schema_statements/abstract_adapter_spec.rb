require 'spec_helper'

describe Spectacles::SchemaStatements::AbstractAdapter do 
  class TestBase
    extend Spectacles::SchemaStatements::AbstractAdapter
    def self.execute(query); query; end 
  end

  describe "#views" do 

    it "throws error when accessed on AbstractAdapter" do 
      lambda { TestBase.views }.must_raise(RuntimeError)
    end

  end
  
  describe "#create_view" do
    let(:view_name) { :view_name }

    it "throws error when block not given and no build_query" do 
      lambda { TestBase.create_view(view_name) }.must_raise(RuntimeError)
    end

    describe "view_name" do

      it "takes a symbol as the view_name" do 
        TestBase.create_view(view_name.to_sym, Product.scoped).must_match(/#{view_name}/)
      end

      it "takes a string as the view_name" do 
        TestBase.create_view(view_name.to_s, Product.scoped).must_match(/#{view_name}/)
      end

    end

    describe "build_query" do 

      it "uses a string if passed" do 
        select_statement = "SELECT * FROM products"
        TestBase.create_view(view_name, select_statement).must_match(/#{Regexp.escape(select_statement)}/)
      end

      it "uses an Arel::Relation if passed" do 
        select_statement = Product.scoped.to_sql
        TestBase.create_view(view_name, Product.scoped).must_match(/#{Regexp.escape(select_statement)}/)
      end

    end

    describe "block" do 
      
      it "can use an Arel::Relation from the yield" do 
        select_statement = Product.scoped.to_sql
        TestBase.create_view(view_name) { Product.scoped }.must_match(/#{Regexp.escape(select_statement)}/)
      end

      it "can use a String from the yield" do 
        select_statement = "SELECT * FROM products"
        TestBase.create_view(view_name) { "SELECT * FROM products" }.must_match(/#{Regexp.escape(select_statement)}/)
      end

    end

    describe "functional" do 
     
      it "creates a view in the db" do 
        
      end

    end

  end

  describe "#drop_view" do
    let(:view_name) { :view_name }

    describe "view_name" do

      it "takes a symbol as the view_name" do 
        TestBase.drop_view(view_name.to_sym).must_match(/#{view_name}/)
      end

      it "takes a string as the view_name" do 
        TestBase.drop_view(view_name.to_s).must_match(/#{view_name}/)
      end

    end

  end

end
