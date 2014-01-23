require "spec_helper"

describe "Element#to_s" do
  html <<-HTML
    <div id="foo"></div>
    <div class="bar"></div>
    <p id="lol" class="bar"></div>
  HTML

  it "returns a string representation of the elements" do
    Element.find('#foo').to_s.should == '#<Element [<div id="foo">]>'
    Element.find('.bar').to_s.should == '#<Element [<div class="bar">, <p id="lol" class="bar">]>'
  end
end
