describe "Element#inspect" do
  before do
    @div = Document.parse <<-HTML
      <div id="insert-spec">
        <div id="foo"></div>
        <div class="bar"></div>
        <p id="lol" class="bar"></div>
      </div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should return a string representation of the elements" do
    Document.id('foo').inspect.should == '(<div id="foo">)'
    Document.find('.bar').inspect.should == '(<div class="bar">, <p id="lol" class="bar">)'
  end

  it "should return '[]' when called on empty element set" do
    Document['.inspect-spec-none'].inspect.should == '()'
  end
end