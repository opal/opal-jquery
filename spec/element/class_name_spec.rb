require "spec_helper"

describe "Element#class_name" do
  html <<-HTML
    <div id="foo" class="whiskey"></div>
    <div id="bar" class="scotch brandy"></div>
    <div id="baz" class=""></div>
    <div id="buz"></div>

    <div class="red dark"></div>
    <div class="red light"></div>
  HTML

  it "should return the elements' class name" do
    Document.id('foo').class_name.should == "whiskey"
    Document.id('bar').class_name.should == "scotch brandy"
  end

  it "should return an empty string for element with no class name" do
    Document.id('baz').class_name.should == ""
    Document.id('buz').class_name.should == ""
  end

  it "should return class name for first element if more than 1 in set" do
    Document.find('.red').class_name.should == "red dark"
  end

  it "should return an empty string for instances with no elements" do
    Document.find('.no-elements').class_name.should == ""
  end
end

describe "Element#class_name=" do
  before do
    @div = Document.parse <<-HTML
      <div id="class-name-set-spec">
        <div id="foo" class=""></div>
        <div id="bar" class="oranges"></div>

        <div id="baz" class="banana"></div>
        <div id="buz" class="banana"></div>
      </div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should set the given class name on the element" do
    Document.id('foo').class_name = "apples"
    Document.id('foo').class_name.should == "apples"
  end

  it "should replace any existing class name" do
    bar = Document.id('bar')
    bar.class_name.should == "oranges"

    bar.class_name = "lemons"
    bar.class_name.should == "lemons"
  end

  it "should set the class name on all elements in instance" do
    el = Document.find '.banana'
    el.length.should == 2

    el.class_name = "pop"

    Document.id('baz').class_name.should == "pop"
    Document.id('buz').class_name.should == "pop"
  end
end
