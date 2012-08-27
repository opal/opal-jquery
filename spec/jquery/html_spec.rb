describe "JQuery#html" do
  before do
    @div = Document.parse <<-HTML
      <div id="html-spec">
        <div id="foo">Hey there</div>
        <div id="bar"><p>Erm</p></div>

        <div class="bridge">Hello</div>
        <div class="bridge">Hello as well</div>
      </div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should return the html content of the element" do
    Document.id('foo').html.should == "Hey there"
    Document.id('bar').html.should == "<p>Erm</p>"
  end

  it "should only return html for first matched element" do
    Document.find('.bridge').html.should == "Hello"
  end

  it "should return empty string for empty set" do
    Document.find('.nothing-here').html.should == ""
  end
end