describe "Element#[]=" do
  before do
    @div = Element.new

    @div.id = 'attr-set-spec'
    @div.html = <<-HTML
      <div id="foo" title="Apples"></div>
      <div id="bar"></div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should set the attr value on the element" do
    bar = Element.id 'bar'
    bar[:title].should == ""

    bar[:title] = "Oranges"
    bar[:title].should == "Oranges"
  end

  it "should replace the old value for the attribute" do
    foo = Element.id 'foo'
    foo[:title].should == "Apples"

    foo[:title] = "Pineapple"
    foo[:title].should == "Pineapple"
  end
end