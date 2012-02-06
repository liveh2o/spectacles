require 'spec_helper'

describe "Spectacles::SchemaStatements::MysqlAdapter" do
  config = {
    :adapter => "mysql",
    :host => "localhost",
    :username => "root"
  }
  configure_database(config)
  recreate_database("spectacles_test")
  load_schema

  it_behaves_like "an adapter", "MysqlAdapter"
end
