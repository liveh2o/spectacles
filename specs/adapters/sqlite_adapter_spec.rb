require 'spec_helper'
require 'spectacles/schema_statements/sqlite_adapter'

describe "Spectacles::SchemaStatements::SQLiteAdapter" do
  File.delete(File.expand_path(File.dirname(__FILE__) + "/../test.db")) rescue nil

  ActiveRecord::Base.establish_connection(
    :adapter => "sqlite3",
    :database => "specs/test.db"
  )  
  load_schema

  it_behaves_like "an adapter", "SQLiteAdapter"
  it_behaves_like "a view model"
end
