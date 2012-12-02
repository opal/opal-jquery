require "spec_helper"

describe "Element#append_to" do
  html <<-HTML
    <div id="foo"></div>
    <div id="bar"></div>
    <div id="baz"></div>
  HTML

  it "should insert the receiver into the target element" do
    Document.id('foo').children.size.should == 0

    Document.parse('<ul class="kapow"></ul>').append_to Document.id('foo')
    Document.id('foo').children.class_name.should == "kapow"

    Document.id('bar').append_to Document.id('baz')
    Document.id('baz').children.id.should == "bar"
  end
end
