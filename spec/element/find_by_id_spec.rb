require File.expand_path('../../spec_helper', __FILE__)

describe "Element.find_by_id" do
  before do
    @div = Element.new :div
    @div.id = :find_by_id_spec
    @div.html = '<div id="foo"></div><div id="bar"></div>'

    Element.body << @div
  end

  after do
    @div.remove
  end

  it "should return nil when no elements with the given id exist" do
    Element.find_by_id('bad_element_id').should be_nil
    Element.find_by_id('blah_blip').should be_nil
  end

  it "should return an Element instance when a matching element is found" do
    Element.find_by_id('foo').should be_kind_of Element
    Element.find_by_id('bar').should be_kind_of Element
  end

  it "should return the same element for successive calls with same id" do
    Element.find_by_id('foo').should == Element.find_by_id('foo')
  end
end
