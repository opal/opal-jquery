describe "JQuery#add_class" do
  before do
    @div = Document.parse <<-HTML
      <div id="add-class-spec">
        <div id="foo"></div>
        <div id="bar" class="apples"></div>
        <div id="baz"></div>
      </div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should add the given class name to the element" do
    foo = Document.id 'foo'
    foo.has_class?('lemons').should be_false
    foo.add_class 'lemons'
    foo.has_class?('lemons').should be_true
  end

  it "should not duplicate class names on an element" do
    bar = Document.id 'bar'
    bar.has_class?('apples').should be_true
    bar.add_class 'apples'
    bar.class_name.should == 'apples'
  end

  it "should return self" do
    baz = Document.id 'baz'
    baz.add_class('oranges').should equal(baz)
    baz.add_class('oranges').should equal(baz)
  end
end