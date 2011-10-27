require File.expand_path('../../spec_helper', __FILE__)

describe "Element#empty?" do
  before do
    @div = Element.new :div
    @div.id = :empty_spec
    @div.html = <<-HTML
      <div id="foo"></div>
      <div id="bar">

      </div>

      <div id="baz">
        <span></span>
      </div>

      <div id="biz">Hello</div>
    HTML

    Element.body << @div
  end

  after do
    Element.body.remove @div
  end

  it "returns true if the element has no children" do
    Element.find_by_id('foo').empty?.should == true
    Element.find_by_id('baz').empty?.should == false
    Element.find_by_id('biz').empty?.should == false
  end

  it "returns true if there is just whitespace in the element" do
    Element.find_by_id('bar').empty?.should == true
  end
end
