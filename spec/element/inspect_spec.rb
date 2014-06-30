require "spec_helper"

describe "Element#inspect" do
  html <<-HTML
    <div id="foo"></div>
    <div class="bar"></div>
    <p id="lol" class="bar"></div>
  HTML

  it "returns a string representation of the elements" do
    Element.find('#foo').inspect.should == '#<Element [<div id="foo">]>'
    Element.find('.bar').inspect.should == '#<Element [<div class="bar">, <p id="lol" class="bar">]>'
  end

  it "returns '[]' when called on empty element set" do
    Element.find('.inspect-spec-none').inspect.should == '#<Element []>'
  end

  it "returns '[]' when called on empty element set" do
    Element.find('.inspect-spec-none').inspect.should == '#<Element []>'
  end

  it "returns '[document]' when called on $(document)" do
    Element.find(`document`).inspect.should == '#<Element [document]>'
  end

  it "returns '[window]' when called on $(window)" do
    Element.find(`window`).inspect.should == '#<Element [window]>'
  end
end
