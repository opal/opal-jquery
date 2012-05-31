describe "Element#inspect" do
  before do
    @div = Element.new

    @div.id = 'inspect-spec'
    @div.html = <<-HTML
      <div id="foo"></div>
      <div class="bar"></div>
      <p id="lol" class="bar"></div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should return a string representation of the elements" do
    Element.id('foo').inspect.should == '[<div id="foo">]'
    Element.find('.bar').inspect.should == '[<div class="bar">, <p id="lol" class="bar">]'
  end

  it "should return '[]' when called on empty element set" do
    Element.find('.inspect-spec-none').inspect.should == '[]'
  end
end