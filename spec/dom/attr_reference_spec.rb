describe "DOM#[]" do
  before do
    @div = DOM.new

    @div.id = 'attr-reference-spec'
    @div.html = <<-HTML
      <div id="foo" title="Hello there!"></div>
      <div id="bar"></div>
      <div id="baz" title=""></div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should retrieve the attr value from the element" do
    DOM.id('foo')[:title].should == "Hello there!"
  end

  it "should return an empty string for an empty attribute value" do
    DOM.id('bar')[:title].should == ""
    DOM.id('baz')[:title].should == ""
  end
end