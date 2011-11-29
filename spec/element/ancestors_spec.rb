require File.expand_path('../../spec_helper', __FILE__)

describe "Element#ancestors" do
  before do
    @div = Element.new :div
    @div.id = :ancestors_spec
    @div.html = <<-HTML
      <div id="foo">
        <div id="bar">
        </div>
      </div>
    HTML

    Element.body << @div
  end

  after do
    @div.remove
  end

  it "should return an array of elements including <html>" do
    @div.ancestors.should == [Element.body, Element.html]
    Element.body.ancestors.should == [Element.html]
    Element.query('#bar').ancestors.size.should == 4
  end

  it "should return an empty array when called on <html>" do
    Element.html.ancestors.size.should == 0
    Element.html.ancestors.should == []
  end
end
