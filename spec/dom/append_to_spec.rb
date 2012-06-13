describe "DOM#append_to" do
  before do
    @div = DOM.parse <<-HTML
      <div id="foo"></div>
      <div id="bar"></div>
      <div id="baz"></div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should insert the receiver into the target element" do
    DOM.id('foo').children.size.should == 0

    DOM.parse('<ul class="kapow"></ul>').append_to DOM.id('foo')
    DOM.id('foo').children.class_name.should == "kapow"

    DOM.id('bar').append_to DOM.id('baz')
    DOM.id('baz').children.id.should == "bar"
  end
end