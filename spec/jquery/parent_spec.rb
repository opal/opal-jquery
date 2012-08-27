describe "JQuery#parent" do
  before do
    @div = Document.parse <<-HTML
      <div id="foo">
        <div id="bar">
          <div id="baz"></div>
          <div id="buz"></div>
        </div>
      </div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should return the parent of the element" do
    Document.id('bar').parent.id.should == "foo"
    Document.id('baz').parent.id.should == "bar"
    Document.id('buz').parent.id.should == "bar"
  end
end