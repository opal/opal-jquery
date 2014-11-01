require "spec_helper"

describe "Element#to_s" do
  html <<-HTML
    <div id="foo">hi</div>
    <div class="bar"></div>
    <p id="lol" class="bar"></div>
  HTML

  it "returns a string representation of the elements" do
    Element.find('#foo').to_s.should == '<div id="foo">hi</div>'
    Element.find('.bar').to_s.should == '<div class="bar"></div>, <p id="lol" class="bar"></p>'
  end
end
