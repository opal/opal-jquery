require "spec_helper"

describe Document do
  html <<-HTML
    <div id="foo" class="bar"></div>
    <div class="woosh"></div>
    <div class="woosh"></div>
    <div class="find-foo"></div>
    <div class="find-bar"></div>
    <div class="find-foo"></div>
  HTML

  describe ".[]" do
    it "should be able to find elements with given id" do
      Element['#foo'].class_name.should == "bar"
      Element['#foo'].size.should == 1
    end

    it "should be able to match any valid CSS selector" do
      Element['.woosh'].should be_kind_of(Element)
      Element['.woosh'].size.should == 2
    end

    it "should return an empty Elements instance when not matching any elements" do
      dom = Element['.some-non-existing-class']

      dom.should be_kind_of(Element)
      dom.size.should == 0
    end

    it "should accept an HTML string and parse it into a Elements instance" do
      el = Element['<div id="foo-bar-baz"></div>']

      el.should be_kind_of(Element)
      el.id.should == "foo-bar-baz"
      el.size.should == 1
    end
  end

  describe ".find" do
    it "should find all elements matching CSS selector" do
      foo = Element.find '.find-foo'
      foo.should be_kind_of(Element)
      foo.length.should == 2

      bar = Element.find '.find-bar'
      bar.should be_kind_of(Element)
      bar.length.should == 1
    end

    it "should return an empty Element instance with length 0 when no matching" do
      baz = Element.find '.find-baz'
      baz.should be_kind_of(Element)
      baz.length.should == 0
    end
  end

  describe '.id' do
    it "should return a new instance with the element with given id" do
      Element.id('foo').should be_kind_of(Element)
      Element.id('foo').id.should == 'foo'
    end

    it "should return nil if no element could be found" do
      Element.id('bad-element-id').should be_nil
    end
  end

  describe '.parse' do
    it "should return a new instance with parsed element as single element" do
      foo = Element.parse '<div id="foo" class="bar"></div>'
      foo.id.should == 'foo'
      foo.class_name.should == 'bar'
    end
  end

  describe '.title and .title=' do
    it 'sets/gets the page title' do
      current = Document.title
      Document.title = 'hello from opal'
      Document.title.should == 'hello from opal'
      Document.title = current
    end
  end
end
