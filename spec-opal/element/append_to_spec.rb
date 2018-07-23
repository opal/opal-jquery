require "spec_helper"

RSpec.describe "Element#append_to" do
  html <<-HTML
    <div id="foo"></div>
    <div id="bar"></div>
    <div id="baz"></div>
  HTML

  it "should insert the receiver into the target element" do
    Element.find('#foo').children.size.should == 0

    Element.parse('<ul class="kapow"></ul>').append_to Element.find('#foo')
    Element.find('#foo').children.class_name.should == "kapow"

    Element.find('#bar').append_to Element.find('#baz')
    Element.find('#baz').children.id.should == "bar"
  end
end
