require "spec_helper"

RSpec.describe "Element#at" do
  html <<-HTML
    <div class="foo" id="blah"></div>
    <div class="foo" id="bleh"></div>
    <div class="foo" id="bluh"></div>
  HTML

  it "returns the element at the given index" do
    foos = Element.find '.foo'
    foos.length.should == 3

    foos.at(0).id.should == "blah"
    foos.at(1).id.should == "bleh"
    foos.at(2).id.should == "bluh"
  end

  it "counts from the last index for negative values" do
    foos = Element.find '.foo'

    foos.at(-1).id.should == "bluh"
    foos.at(-2).id.should == "bleh"
    foos.at(-3).id.should == "blah"
  end

  it "returns nil for indexes outside range" do
    foos = Element.find '.foo'

    foos.at(-4).should == nil
    foos.at(4).should == nil
  end
end
