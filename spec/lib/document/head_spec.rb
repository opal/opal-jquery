require File.expand_path('../../../spec_helper', __FILE__)

describe "Document.head" do
  it "should return the head element from the page" do
    a = $document.head
    a.tag.should == "head"
  end

  it "should only contain a single element" do
    a = $document.head
    a.length.should == 1
  end
end

