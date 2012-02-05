require 'spec_helper'

describe "Spectacles::SchemaStatements::PostgreSQLAdapter" do
  database = "spectacles_test"

  config = {
    :adapter => "postgresql",
    :host => "localhost",
    :username => "postgres",
    :database => "postgres",
    :min_messages => "error"
  }

  ActiveRecord::Base.silence do  
    ActiveRecord::Base.establish_connection(config)

    ActiveRecord::Base.connection.drop_database(database) rescue nil
    ActiveRecord::Base.connection.create_database(database)

    ActiveRecord::Base.establish_connection(config.merge(:database => database))
  end
  
  load_schema

  it_behaves_like "an adapter", "PostgreSQLAdapter"
end
