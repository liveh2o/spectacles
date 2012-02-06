require 'spec_helper'

describe "Spectacles::SchemaStatements::Mysql2Adapter" do
  database = "spectacles_test"

  config = {
    :adapter => "mysql2",
    :host => "localhost",
    :username => "root"
  }

  recreate_database(config, database)
  ActiveRecord::Base.establish_connection(config.merge(:database => database))  
  load_schema

  it_behaves_like "an adapter", "Mysql2Adapter"
end
