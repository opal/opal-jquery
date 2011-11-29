require File.expand_path('../../spec_helper', __FILE__)

describe "Element#remove" do
  before do
    @div = Element.new :div
    @div.id = :remove_spec
    @div.html = <<-HTML
      <div id="foo1">
        <div id="bar1"></div>
      </div>
      <div id="foo2">
        <div id="bar2"></div>
      </div>
    HTML

    Element.body << @div
  end

  after do
    @div.remove
  end

  it "should return the element upon removal" do
    bar1 = Element.query('#bar1')
    bar1.remove.should == bar1
  end

  it "should completely remove the element from its parent" do
    Element.query('#bar2').remove
    Element.query('#foo2').empty?.should be_true
  end
end
