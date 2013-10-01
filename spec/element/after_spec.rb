require "spec_helper"

describe "Element#after" do
  html <<-HTML
    <div id="some-header" class="kapow"></div>
    <div id="foo" class="after-spec-first"></div>
    <div id="bar" class="after-spec-first"></div>
    <div id="baz"></div>
  HTML

  it "should insert the given html string after each element" do
    el = Element.find('.after-spec-first')
    el.size.should == 2

    el.after '<p class="woosh"></p>'

    Element.find('#foo').next.class_name.should == "woosh"
    Element.find('#bar').next.class_name.should == "woosh"
  end

  it "should insert the given DOM element after this element" do
    Element.find('#baz').after Element.find('#some-header')
    Element.find('#baz').next.id.should == "some-header"
  end
end
