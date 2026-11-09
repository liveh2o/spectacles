require "test_helper"

describe "Spectacles::SchemaStatements::TrilogyAdapter" do
  config = {
    adapter: "trilogy",
    host: ENV["MYSQL_HOST"] || "127.0.0.1",
    port: ENV.fetch("MYSQL_PORT", 3306).to_i,
    username: ENV["MYSQL_USER"] || "root",
    password: ENV["MYSQL_PASSWORD"],
    # MySQL 8 caching_sha2_password auth needs TLS over TCP.
    ssl: true
  }

  configure_database(config)
  recreate_database("spectacles_test")
  load_schema

  it_behaves_like "an adapter", "TrilogyAdapter"
  it_behaves_like "a view model"
end
