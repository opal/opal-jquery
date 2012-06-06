describe "Element#first" do
  before do
    @div = Element.new

    @div.id = 'first-spec'
    @div.html = <<-HTML
      <div id="foo" class="bar"></div>
      <div id="buz" class="bar"></div>
      <div id="biz" class="bar"></div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should return the first element in the receiver" do
    Element.find('.bar').first.id.should == 'foo'
    Element.id('biz').first.id.should == 'biz'
  end

  it "should return nil when receiver has no elements" do
    Element.find('.some-random-class').first.should == nil
  end
end