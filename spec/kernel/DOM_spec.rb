describe "Kernel#DOM" do
  before do
    @div = DOM.parse <<-HTML
      <div id="foo" class="bar"></div>
      <div class="woosh"></div>
      <div class="woosh"></div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should be able to find elements with given id" do
    DOM('#foo').class_name.should == "bar"
    DOM('#foo').size.should == 1
  end

  it "should be able to match any valid CSS selector" do
    DOM('.woosh').should be_kind_of(DOM)
    DOM('.woosh').size.should == 2
  end

  it "should return an empty DOM instance when not matching any elements" do
    dom = DOM('.some-non-existing-class')

    dom.should be_kind_of(DOM)
    dom.size.should == 0
  end

  it "should accept an HTML string and parse it into a DOM instance" do
    el = DOM('<div id="foo-bar-baz"></div>')

    el.should be_kind_of(DOM)
    el.id.should == "foo-bar-baz"
    el.size.should == 1
  end
end