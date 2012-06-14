describe "DOM.find" do
  before do
    @div = DOM.parse <<-HTML
      <div id="find-spec">
        <div class="find-foo"></div>
        <div class="find-bar"></div>
        <div class="find-foo"></div>
      </div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should find all elements matching CSS selector" do
    foo = DOM.find '.find-foo'
    foo.should be_kind_of(DOM)
    foo.length.should == 2

    bar = DOM.find '.find-bar'
    bar.should be_kind_of(DOM)
    bar.length.should == 1
  end

  it "should return an empty DOM instance with length 0 when no matching" do
    baz = DOM.find '.find-baz'
    baz.should be_kind_of(DOM)
    baz.length.should == 0
  end
end

describe "DOM#find" do
  before do
    @div = DOM <<-HTML
      <div id="find-spec">
        <div id="foo">
          <p class="bar"></p>
          <p class="baz"></p>
          <p class="bar"></p>
        </div>
        <div id="bar"></div>
      </div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should match all elements within scope of receiver" do
    foo = DOM '#foo'
    foo.find('.bar').size.should == 2
    foo.find('.baz').size.should == 1
  end

  it "should return an empty collection if there are no matching elements" do
    bar = DOM '#bar'
    bar.find('.woosh').size.should == 0
  end
end