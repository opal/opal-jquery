describe "Element#html" do
  before do
    @div = Element.new

    @div.id = "html-spec"
    @div.html = <<-HTML
      <div id="foo">Hey there</div>
      <div id="bar"><p>Erm</p></div>

      <div class="bridge">Hello</div>
      <div class="bridge">Hello as well</div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should return the html content of the element" do
    Element.id('foo').html.should == "Hey there"
    Element.id('bar').html.should == "<p>Erm</p>"
  end

  it "should only return html for first matched element" do
    Element.find('.bridge').html.should == "Hello"
  end

  it "should return empty string for empty set" do
    Element.find('.nothing-here').html.should == ""
  end
end