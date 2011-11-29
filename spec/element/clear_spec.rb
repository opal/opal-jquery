require File.expand_path('../../spec_helper', __FILE__)

describe "Element#clear" do
  before do
    @div = Element.new :div
    @div.id = :clear_spec
    @div.html = <<-HTML
      <div id="foo">
        <div></div>
        Blah
      </div>
      <div id="bar">
        <span class="a"></span>
      </div>
    HTML

    Element.body.append @div
  end

  after do
    @div.remove
  end

  it "removes all child nodes and returns self" do
    e = Element.query '#foo'
    e.clear.should == e
  end

  it "leaves the element empty" do
    e = Element.query '#bar'
    e.clear
    e.empty?.should == true
  end
end
