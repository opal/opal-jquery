describe "DOM#add_class" do
  before do
    @div = DOM.new

    @div.id = 'add-class-spec'
    @div.html = <<-HTML
      <div id="foo"></div>
      <div id="bar" class="apples"></div>
      <div id="baz"></div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should add the given class name to the element" do
    foo = DOM.id 'foo'
    foo.has_class?('lemons').should be_false
    foo.add_class 'lemons'
    foo.has_class?('lemons').should be_true
  end

  it "should not duplicate class names on an element" do
    bar = DOM.id 'bar'
    bar.has_class?('apples').should be_true
    bar.add_class 'apples'
    bar.class_name.should == 'apples'
  end

  it "should return self" do
    baz = DOM.id 'baz'
    baz.add_class('oranges').should equal(baz)
    baz.add_class('oranges').should equal(baz)
  end
end