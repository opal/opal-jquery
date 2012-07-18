describe "DOM#value" do
  before do
    @div = DOM.parse <<-HTML
      <div id="value-spec">
        <select id="foo">
          <option selected="selected">Hello</option>
          <option>World</option>
        </select>

        <input id="bar" type="text" value="Blah"></input>
        <div id="baz"></div>
      </div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should return the selected value of select elements" do
    DOM.id('foo').value.should == "Hello"
  end

  it "should return the value of normal input fields" do
    DOM.id('bar').value.should == "Blah"
  end

  it "should return an empty string for elements with no value attr" do
    DOM.id('baz').value.should == ""
  end
end

describe "DOM#value=" do
  before do
    @div = DOM.new

    @div.id = 'value-set-spec'
    @div.html = <<-HTML
      <input type="text" id="foo" value=""></input>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should set the value of the element to the given value" do
    foo = DOM.id 'foo'
    foo.value.should == ""

    foo.value = "Hi"
    foo.value.should == "Hi"

    foo.value = "There"
    foo.value.should == "There"
  end
end