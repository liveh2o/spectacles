require "test_helper"

describe Spectacles::View do
  it "is an abstract class" do
    _(Spectacles::View.abstract_class?).must_equal true
  end
end
