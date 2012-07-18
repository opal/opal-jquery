describe "DOM#parent" do
  before do
    @div = DOM.parse <<-HTML
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
    DOM.id('bar').parent.id.should == "foo"
    DOM.id('baz').parent.id.should == "bar"
    DOM.id('buz').parent.id.should == "bar"
  end
end