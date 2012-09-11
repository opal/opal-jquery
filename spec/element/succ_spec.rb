describe "Element#succ" do
  before do
    @div = Document.parse <<-HTML
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
    Document.id('foo').succ.id.should == "bar"
  end

  it "should return an empty instance when no next element" do
    Document.id('bar').succ.size.should == 0
  end
end