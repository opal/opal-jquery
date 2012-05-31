describe "Element.find" do
  before do
    @div = Element.new

    @div.id = 'find-spec'
    @div.html = <<-HTML
      <div class="find-foo"></div>
      <div class="find-bar"></div>
      <div class="find-foo"></div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should find all elements matching CSS selector" do
    foo = Element.find '.find-foo'
    foo.should be_kind_of(Element)
    foo.length.should == 2

    bar = Element.find '.find-bar'
    bar.should be_kind_of(Element)
    bar.length.should == 1
  end

  it "should return an empty Element instance with length 0 when no matching" do
    baz = Element.find '.find-baz'
    baz.should be_kind_of(Element)
    baz.length.should == 0
  end
end