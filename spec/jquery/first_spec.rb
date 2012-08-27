describe "JQuery#first" do
  before do
    @div = Document.parse <<-HTML
      <div id="first-spec">
        <div id="foo" class="bar"></div>
        <div id="buz" class="bar"></div>
        <div id="biz" class="bar"></div>
      </div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should return the first element in the receiver" do
    Document.find('.bar').first.id.should == 'foo'
    Document.id('biz').first.id.should == 'biz'
  end

  it "should return nil when receiver has no elements" do
    Document.find('.some-random-class').first.should == nil
  end
end