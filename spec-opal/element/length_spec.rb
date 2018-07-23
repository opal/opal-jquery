require "spec_helper"

RSpec.describe "Element#length" do
  it "should report the number of elements in the instance" do
    Element.new.length.should == 1
  end
end
