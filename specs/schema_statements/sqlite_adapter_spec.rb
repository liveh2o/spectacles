require 'spec_helper'

describe Spectacles::SchemaStatements::SQLiteAdapter do
  describe "ActiveRecord::SchemaDumper#dump" do 

    it "should return create_view in dump stream" do 
      stream = StringIO.new
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, stream)
      stream.string.must_match(/create_view/)
    end

  end
end
