require "spec_helper"

RSpec.describe "Element#before" do
  html <<-HTML
    <div id="some-header" class="kapow"></div>
    <div id="foo" class="before-spec-first"></div>
    <div id="bar" class="before-spec-first"></div>
    <div id="baz"></div>
  HTML

  it "should insert the given html string before each element" do
    el = Element.find('.before-spec-first')
    el.size.should == 2

    el.before '<p class="woosh"></p>'

    Element.find('#foo').prev.class_name.should == "woosh"
    Element.find('#bar').prev.class_name.should == "woosh"
  end

  it "should insert the given DOM element before this element" do
    Element.find('#baz').before Element.find('#some-header')
    Element.find('#baz').prev.id.should == "some-header"
  end
end
