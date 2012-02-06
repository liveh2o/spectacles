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
end
