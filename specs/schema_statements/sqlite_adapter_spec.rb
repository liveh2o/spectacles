require 'spec_helper'

describe Spectacles::SchemaStatements::SQLiteAdapter do
  describe "ActiveRecord::SchemaDumper#dump" do 
    before(:each) do
      ActiveRecord::Base.connection.drop_view(:new_product_users)

      ActiveRecord::Base.connection.create_view(:new_product_users) do 
        "SELECT name AS product_name, first_name AS username FROM
        products JOIN users ON users.id = products.user_id"
      end
    end

    it "should return create_view in dump stream" do 
      stream = StringIO.new
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, stream)
      stream.string.must_match(/create_view/)
    end

  end
end
