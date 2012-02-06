require 'spec_helper'

describe "Spectacles::SchemaStatements::MysqlAdapter" do
  database = "spectacles_test"

  config = {
    :adapter => "mysql",
    :host => "localhost",
    :username => "root"
  }

  ActiveRecord::Base.silence do  
    ActiveRecord::Base.establish_connection(config)

    ActiveRecord::Base.connection.drop_database(database) rescue nil
    ActiveRecord::Base.connection.create_database(database)

    ActiveRecord::Base.establish_connection(config.merge(:database => database))
  end
  
  load_schema

  it_behaves_like "an adapter", "MysqlAdapter"
end
