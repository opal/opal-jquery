require 'spec_helper'

RSpec.describe 'Document' do
  subject { Document }

  describe "ready?" do
    it "accepts a block" do
      Document.ready? {
        puts `$.fn.jquery`
      }
    end

    it "accepts a block" do
      Document.ready? { }
    end
  end

  describe "ready" do
    async "resolves when document is ready" do
      Document.ready.then do
        async { Document.ready.resolved?.should be_truthy }
      end
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

  describe "head" do
    it "returns the head element as an Element instance" do
      expect(subject.head).to be_kind_of(Element)
      expect(subject.head.tag_name).to eq('head')
    end
  end

  describe "body" do
    it "returns the body element as an Element instance" do
      expect(subject.body).to be_kind_of(Element)
      expect(subject.body.tag_name).to eq('body')
    end
  end
end
