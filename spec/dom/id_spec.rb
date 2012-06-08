describe "DOM.id" do
  before do
    @div = DOM.parse <<-HTML
      <div id="element-id-spec">
        <div id="foo"></div>
        <div id="bar"></div>
      </div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should return a new instance with the element with given id" do
    DOM.id('foo').should be_kind_of(DOM)
    DOM.id('bar').id.should == 'bar'
  end

  it "should return nil if no element could be found" do
    DOM.id('bad-element-id').should be_nil
  end
end