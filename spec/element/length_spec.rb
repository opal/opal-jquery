require "spec_helper"

describe "Element#length" do
  html <<-HTML
    <div id="foo-bar-baz"></div>
  HTML

  it "should report the number of elements in the instance" do
    Element.find("#foo-bar-baz").length.should == 1
  end
end
