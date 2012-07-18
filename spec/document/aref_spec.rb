describe "Document.[]" do
  before do
    @div = Document.parse <<-HTML
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
    Document['#foo'].class_name.should == "bar"
    Document['#foo'].size.should == 1
  end

  it "should be able to match any valid CSS selector" do
    Document['.woosh'].should be_kind_of(Element)
    Document['.woosh'].size.should == 2
  end

  it "should return an empty Element instance when not matching any elements" do
    dom = Document['.some-non-existing-class']

    dom.should be_kind_of(Element)
    dom.size.should == 0
  end

  it "should accept an HTML string and parse it into a element instance" do
    el = Document['<div id="foo-bar-baz"></div>']

    el.should be_kind_of(Element)
    el.id.should == "foo-bar-baz"
    el.size.should == 1
  end
end