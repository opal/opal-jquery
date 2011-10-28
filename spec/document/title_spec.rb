require File.expand_path('../../spec_helper', __FILE__)

describe "Document.title" do
  it "should return the current page's title" do
    Document.title.should == "RQuery Spec Runner"
  end
end

describe "Document.title=" do
  it "should set the document's title to the given string" do
    old = Document.title

    Document.title = "ZOMG"
    Document.title.should == "ZOMG"

    Document.title = old
    Document.title.should == old
  end
end
