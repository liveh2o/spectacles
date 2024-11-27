require "test_helper"

describe Spectacles::SchemaStatements::AbstractAdapter do
  describe "#create_view" do
    it "throws error when block not given and no build_query" do
      _(lambda { TestBase.create_view(:view_name) }).must_raise(RuntimeError)
    end
  end

  describe "#views" do
    it "throws error when accessed on AbstractAdapter" do
      _(lambda { TestBase.views }).must_raise(RuntimeError)
    end
  end

  describe "#supports_materialized_views?" do
    it "returns false when accessed on AbstractAdapter" do
      _(TestBase.supports_materialized_views?).must_equal false
    end
  end

  describe "#materialized_views" do
    it "throws error when accessed on AbstractAdapter" do
      _(lambda { TestBase.materialized_views }).must_raise(NotImplementedError)
    end
  end

  describe "#materialized_view_exists?" do
    it "is true when materialized_views includes the view" do
      TestBase.with_materialized_views(%w[alpha beta gamma]) do
        _(TestBase.materialized_view_exists?(:beta)).must_equal true
      end
    end

    it "is false when materialized_views does not include the view" do
      TestBase.with_materialized_views(%w[alpha beta gamma]) do
        _(TestBase.materialized_view_exists?(:delta)).must_equal false
      end
    end
  end

  describe "#materialized_view_build_query" do
    it "throws error when accessed on AbstractAdapter" do
      _(lambda { TestBase.materialized_view_build_query(:books) }).must_raise(NotImplementedError)
    end
  end

  describe "#create_materialized_view" do
    it "throws error when accessed on AbstractAdapter" do
      _(lambda { TestBase.create_materialized_view(:books) }).must_raise(NotImplementedError)
    end
  end

  describe "#drop_materialized_view" do
    it "throws error when accessed on AbstractAdapter" do
      _(lambda { TestBase.drop_materialized_view(:books) }).must_raise(NotImplementedError)
    end
  end

  describe "#refresh_materialized_view" do
    it "throws error when accessed on AbstractAdapter" do
      _(lambda { TestBase.refresh_materialized_view(:books) }).must_raise(NotImplementedError)
    end
  end
end
