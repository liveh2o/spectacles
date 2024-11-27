require "test_helper"

describe "Spectacles::SchemaStatements::PostgreSQLAdapter" do
  config = {
    adapter: "postgresql",
    host: ENV["POSTGRES_HOST"] || "localhost",
    username: ENV["POSTGRES_USER"] || "postgres",
    port: ENV["POSTGRES_port"] || 5432
  }
  configure_database(config)
  recreate_database("spectacles_test")
  load_schema

  it_behaves_like "an adapter", "PostgreSQLAdapter"
  it_behaves_like "a view model"

  test_base = Class.new do
    extend Spectacles::SchemaStatements::PostgreSQLAdapter
    def self.schema_search_path
      ""
    end

    def self.select_value(_, _)
      "\"products\""
    end

    def self.quote_table_name(name)
      name
    end

    def self.quote_column_name(name)
      name
    end
  end

  describe "#view_build_query" do
    it "should escape double-quotes returned by Postgres" do
      _(test_base.view_build_query(:new_product_users)).must_match(/\\"/)
    end
  end

  describe "#materialized_views" do
    it "should support materialized views" do
      _(test_base.supports_materialized_views?).must_equal true
    end
  end

  describe "#create_materialized_view_statement" do
    it "should work with no options" do
      query = test_base.create_materialized_view_statement(:view_name, "select_query_here")
      _(query).must_match(/create materialized view view_name as select_query_here with data/i)
    end

    it "should allow column names to be specified" do
      query = test_base.create_materialized_view_statement(:view_name, "select_query_here",
        columns: %i[first second third])
      _(query).must_match(/create materialized view view_name \(first,second,third\) as select_query_here with data/i)
    end

    it "should allow storage parameters to be specified" do
      query = test_base.create_materialized_view_statement(:view_name, "select_query_here",
        storage: {bats_in_belfry: true, max_wingspan: 15})
      _(query).must_match(/create materialized view view_name with \(bats_in_belfry=true, max_wingspan=15\) as select_query_here with data/i)
    end

    it "should allow tablespace to be specified" do
      query = test_base.create_materialized_view_statement(:view_name, "select_query_here",
        tablespace: :the_final_frontier)
      _(query).must_match(/create materialized view view_name tablespace the_final_frontier as select_query_here with data/i)
    end

    it "should allow empty view to be created" do
      query = test_base.create_materialized_view_statement(:view_name, "select_query_here",
        data: false)
      _(query).must_match(/create materialized view view_name as select_query_here with no data/i)
    end
  end
end
