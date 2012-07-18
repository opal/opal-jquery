describe "Element#before" do
  before do
    @div = Document.parse <<-HTML
      <div id="before-spec">
        <div id="some-header" class="kapow"></div>
        <div id="foo" class="before-spec-first"></div>
        <div id="bar" class="before-spec-first"></div>
        <div id="baz"></div>
      </div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should insert the given html string before each element" do
    el = Document['.before-spec-first']
    el.size.should == 2

    el.before '<p class="woosh"></p>'

    Document['#foo'].prev.class_name.should == "woosh"
    Document['#bar'].prev.class_name.should == "woosh"
  end

  it "should insert the given DOM element before this element" do
    Document['#baz'].before Document['#some-header']
    Document['#baz'].prev.id.should == "some-header"
  end
end