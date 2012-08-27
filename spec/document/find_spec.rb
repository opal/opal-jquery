describe "Document.find" do
  before do
    @div = Document.parse <<-HTML
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
    foo = Document.find '.find-foo'
    foo.should be_kind_of(JQuery)
    foo.length.should == 2

    bar = Document.find '.find-bar'
    bar.should be_kind_of(JQuery)
    bar.length.should == 1
  end

  it "should return an empty Element instance with length 0 when no matching" do
    baz = Document.find '.find-baz'
    baz.should be_kind_of(JQuery)
    baz.length.should == 0
  end
end