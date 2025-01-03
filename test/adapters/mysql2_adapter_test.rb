require "test_helper"

describe "Spectacles::SchemaStatements::Mysql2Adapter" do
  config = {
    adapter: "mysql2",
    host: ENV["MYSQL_HOST"] || "localhost",
    username: ENV["MYSQL_USER"] || "root",
    password: ENV["MYSQL_PASSWORD"]
  }

  if defined? JRUBY_VERSION
    config[:properties] ||= {}
    config[:properties]["allowPublicKeyRetrieval"] = true
  end

  configure_database(config)
  recreate_database("spectacles_test")
  load_schema

  it_behaves_like "an adapter", "Mysql2Adapter"
  it_behaves_like "a view model"
end
