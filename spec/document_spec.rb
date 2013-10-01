require 'spec_helper'

describe Document do
  describe "ready?" do
    it "accepts a block" do
      Document.ready? { }
    end
  end

  describe "title" do
    it "gets the document title" do
      Document.title.should be_kind_of(String)
    end
  end

  describe "title=" do
    it "sets the document title" do
      old = Document.title
      Document.title = "foo"
      Document.title.should eq("foo")
      Document.title = old
    end
  end
end
