describe "JQuery#append" do
  before do
    @div = Document.parse <<-HTML
      <div id="append-spec">
        <div id="foo" class="first-append"></div>
        <div id="bar" class="first-append"></div>
        <div id="baz"></div>
        <div id="buz"></div>
      </div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should insert the HTML string to the end of each element" do
    Document.find('.first-append').append '<p class="woosh"></p>'

    Document.id('foo').children.class_name.should == "woosh"
    Document.id('bar').children.class_name.should == "woosh"
  end

  it "should insert the given DOM node at the end of the element" do
    baz = Document.id 'baz'
    buz = Document.id 'buz'

    baz.children.size.should == 0
    baz.append buz

    baz.children.size.should == 1
    baz.children.id.should == "buz"
  end
end