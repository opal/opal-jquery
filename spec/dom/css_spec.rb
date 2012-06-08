describe "DOM#css" do
  before do
    @div = DOM.new

    @div.id = 'css-spec'
    @div.html = <<-HTML
      <div id="foo" style="background-color:rgb(15,99,30); color:;"></div>
      <div id="bar"></div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  describe "with a given name" do
    it "returns the value of the CSS property for the given name" do
      DOM.id('foo').css('backgroundColor').should be_kind_of(String)
    end

    it "should return an empty string when no style property is defined for name" do
      DOM.id('foo').css('color').should be_kind_of(String)
    end
  end

  describe "with a name and value" do
    it "should set the CSS property to the given value" do
      DOM.id('bar').css('backgroundColor', 'blue')
    end

    it "returns self" do
      bar = DOM.id('bar')
      bar.css('color', 'green').should equal(bar)
    end
  end
end