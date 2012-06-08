describe "Element.parse" do
  it "should return a new instance with parsed element as single element" do
    foo = Element.parse '<div id="foo" class="bar"></div>'
    foo.id.should == 'foo'
    foo.class_name.should == 'bar'
  end
end