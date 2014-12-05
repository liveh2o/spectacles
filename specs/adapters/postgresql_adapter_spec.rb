require 'spec_helper'

describe "Spectacles::SchemaStatements::PostgreSQLAdapter" do
  config = {
    :adapter => "postgresql",
    :host => "localhost",
    :username => "postgres",
    :database => "postgres",
    :min_messages => "error"
  }
  configure_database(config)
  recreate_database("spectacles_test")
  load_schema

  it_behaves_like "an adapter", "PostgreSQLAdapter"
  it_behaves_like "a view model"

  describe "#view_build_query" do
    test_base = Class.new do
      extend Spectacles::SchemaStatements::PostgreSQLAdapter
      def self.schema_search_path; ""; end
      def self.select_value(_, _); "\"products\""; end;
    end

    it "should escape double-quotes returned by Postgres" do
      test_base.view_build_query(:new_product_users).must_match(/\\"/)
    end
  end
end
