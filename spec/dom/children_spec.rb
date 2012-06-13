describe "DOM#children" do
  before do
    @div = DOM.parse <<-HTML
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
    DOM.id('foo').children.size.should == 0
    DOM.id('bar').children.size.should == 2
  end

  it "should only return direct children" do
    c = DOM.id('baz').children
    c.size.should == 1
  end
end