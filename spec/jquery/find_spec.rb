describe "JQuery#find" do
  before do
    @div = Document.parse <<-HTML
      <div id="find-spec">
        <div id="foo">
          <p class="bar"></p>
          <p class="baz"></p>
          <p class="bar"></p>
        </div>
        <div id="bar"></div>
      </div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should match all elements within scope of receiver" do
    foo = Document['#foo']
    foo.find('.bar').size.should == 2
    foo.find('.baz').size.should == 1
  end

  it "should return an empty collection if there are no matching elements" do
    bar = Document['#bar']
    bar.find('.woosh').size.should == 0
  end
end