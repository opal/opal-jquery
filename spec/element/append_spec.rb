require "spec_helper"

RSpec.describe "Element#append" do
  html <<-HTML
    <div id="foo" class="first-append"></div>
    <div id="bar" class="first-append"></div>
    <div id="baz"></div>
    <div id="buz"></div>
  HTML

  it "should insert the HTML string to the end of each element" do
    Element.find('.first-append').append '<p class="woosh"></p>'

    Element.find('#foo').children.class_name.should == "woosh"
    Element.find('#bar').children.class_name.should == "woosh"
  end

  it "should insert the given DOM node at the end of the element" do
    baz = Element.find('#baz')
    buz = Element.find('#buz')

    baz.children.size.should == 0
    baz.append buz

    baz.children.size.should == 1
    baz.children.id.should == "buz"
  end
end
