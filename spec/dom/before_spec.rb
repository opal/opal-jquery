describe "DOM#before" do
  before do
    @div = DOM <<-HTML
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
    el = DOM('.before-spec-first')
    el.size.should == 2

    el.before '<p class="woosh"></p>'

    DOM('#foo').prev.class_name.should == "woosh"
    DOM('#bar').prev.class_name.should == "woosh"
  end

  it "should insert the given DOM element before this element" do
    DOM('#baz').before DOM('#some-header')
    DOM('#baz').prev.id.should == "some-header"
  end
end