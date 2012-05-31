describe "Element#class_name" do
  before do
    @div = Element.new

    @div.id = 'class-name-spec'
    @div.html = <<-HTML
      <div id="foo" class="whiskey"></div>
      <div id="bar" class="scotch brandy"></div>
      <div id="baz" class=""></div>
      <div id="buz"></div>

      <div class="red dark"></div>
      <div class="red light"></div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should return the elements' class name" do
    Element.id('foo').class_name.should == "whiskey"
    Element.id('bar').class_name.should == "scotch brandy"
  end

  it "should return an empty string for element with no class name" do
    Element.id('baz').class_name.should == ""
    Element.id('buz').class_name.should == ""
  end

  it "should return class name for first element if more than 1 in set" do
    Element.find('.red').class_name.should == "red dark"
  end

  it "should return an empty string for instances with no elements" do
    Element.find('.no-elements').class_name.should == ""
  end
end

describe "Element#class_name=" do
  before do
    @div = Element.new

    @div.id = 'class-name-set-spec'
    @div.html = <<-HTML
      <div id="foo" class=""></div>
      <div id="bar" class="oranges"></div>

      <div id="baz" class="banana"></div>
      <div id="buz" class="banana"></div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should set the given class name on the element" do
    Element.id('foo').class_name = "apples"
    Element.id('foo').class_name.should == "apples"
  end

  it "should replace any existing class name" do
    bar = Element.id('bar')
    bar.class_name.should == "oranges"

    bar.class_name = "lemons"
    bar.class_name.should == "lemons"
  end

  it "should set the class name on all elements in instance" do
    el = Element.find '.banana'
    el.length.should == 2

    el.class_name = "pop"

    Element.id('baz').class_name.should == "pop"
    Element.id('buz').class_name.should == "pop"
  end
end