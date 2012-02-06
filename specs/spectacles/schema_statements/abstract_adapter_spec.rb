require 'spec_helper'

describe Spectacles::SchemaStatements::AbstractAdapter do 
  class TestBase
    extend Spectacles::SchemaStatements::AbstractAdapter
  end

  describe "#create_view" do
    it "throws error when block not given and no build_query" do 
      lambda { TestBase.create_view(:view_name) }.must_raise(RuntimeError)
    end
  end

  describe "#views" do 
    it "throws error when accessed on AbstractAdapter" do 
      lambda { TestBase.views }.must_raise(RuntimeError)
    end
  end
end
