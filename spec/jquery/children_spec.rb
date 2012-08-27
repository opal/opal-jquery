describe "JQuery#children" do
  before do
    @div = Document.parse <<-HTML
      <div id="children-spec">
        <div id="foo"></div>
        <div id="bar">
          <p>Hey</p>
          <p>There</p>
        </div>
        <div id="baz">
          <div><p></p></div>
        </div>
      </div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should return a new collection of all direct children of element" do
    Document.id('foo').children.size.should == 0
    Document.id('bar').children.size.should == 2
  end

  it "should only return direct children" do
    c = Document.id('baz').children
    c.size.should == 1
  end
end