require 'spec_helper'

describe Spectacles::View do
  it "is an abstract class" do
    _(Spectacles::View.abstract_class?).must_be true
  end
end
