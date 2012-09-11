describe "Element#[]" do
  before do
    @div = Document.parse <<-HTML
      <div id="attr-reference-spec">
        <div id="foo" title="Hello there!"></div>
        <div id="bar"></div>
        <div id="baz" title=""></div>
      </div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should retrieve the attr value from the element" do
    Document.id('foo')[:title].should == "Hello there!"
  end

  it "should return an empty string for an empty attribute value" do
    Document.id('bar')[:title].should == ""
    Document.id('baz')[:title].should == ""
  end
end