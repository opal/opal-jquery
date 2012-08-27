describe "JQuery#after" do
  before do
    @div = Document.parse <<-HTML
      <div id="after-spec">
        <div id="some-header" class="kapow"></div>
        <div id="foo" class="after-spec-first"></div>
        <div id="bar" class="after-spec-first"></div>
        <div id="baz"></div>
      </div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should insert the given html string after each element" do
    el = Document['.after-spec-first']
    el.size.should == 2

    el.after '<p class="woosh"></p>'

    Document.id('foo').next.class_name.should == "woosh"
    Document.id('bar').next.class_name.should == "woosh"
  end

  it "should insert the given DOM element after this element" do
    Document.id('baz').after Document.id('some-header')
    Document.id('baz').next.id.should == "some-header"
  end
end