describe "Element#remove_clas" do
  before do
    @div = Element.new

    @div.id = 'remove-class-spec'
    @div.html = <<-HTML
      <div id="foo"></div>

      <div id="bar" class="lemons"></div>
      <div id="baz" class="apples oranges"></div>
      <div id="buz" class="pineapples mangos"></div>

      <div id="bleh" class="fruit"></div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should have no effect on elements without class" do
    foo = Element.id 'foo'
    foo.class_name.should == ''
    foo.remove_class 'blah'
    foo.class_name.should == ''
  end

  it "should remove the given class from the element" do
    bar = Element.id 'bar'
    bar.remove_class "lemons"
    bar.class_name.should == ''

    baz = Element.id 'baz'
    baz.remove_class 'lemons'
    baz.class_name.should == 'apples oranges'

    baz.remove_class 'apples'
    baz.class_name.should == 'oranges'

    buz = Element.id 'buz'
    buz.remove_class 'mangos'
    buz.class_name.should == 'pineapples'

    buz.remove_class 'pineapples'
    buz.class_name.should == ''
  end

  it "should return self" do
    bleh = Element.id 'bleh'
    bleh.remove_class('fruit').should equal(bleh)
    bleh.remove_class('hmmmm').should equal(bleh)
  end
end