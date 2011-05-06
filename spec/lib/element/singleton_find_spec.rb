require File.expand_path("../../../spec_helper", __FILE__)

describe "Element.find" do

  before :all do
    parts = ['<div id="singleton_find_spec">']
    parts << '<div id="unique_find_id"></div>'
    parts << '<div id="some_other_id"></div>'
    parts << '</div>'

    $document.body.append parts.join('')
  end

  after :all do
    $document['#singleton_find_spec'].remove
  end

  it "takes a selector and returns a matching Element" do
    elem = RQuery::Element.find '#unique_find_id'

    elem.class.should == RQuery::Element
    elem.length.should == 1
    elem.tag.should == 'div'
  end

  it "should look for an element with matching id when passed a symbol" do
    e = RQuery::Element.find :some_other_id
    e.length.should == 1
    e.tag.should == 'div'
  end
end

