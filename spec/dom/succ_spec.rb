describe "DOM#succ" do
  before do
    @div = DOM.parse <<-HTML
      <div id="succ-spec">
        <div id="foo"></div>
        <div id="bar"></div>
      </div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should return the next sibling" do
    DOM.id('foo').succ.id.should == "bar"
  end

  it "should return an empty instance when no next element" do
    DOM.id('bar').succ.size.should == 0
  end
end