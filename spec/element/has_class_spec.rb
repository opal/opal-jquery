require File.expand_path('../../spec_helper', __FILE__)

describe "Element#has_class?" do
  before do
    @div = Element.new :div
    @div.html = <<-HTML
      <div id="has_class_spec_1"></div>
      <div id="has_class_spec_2" class="foo"></div>
      <div id="has_class_spec_3" class="bar baz"></div>
    HTML

    Element.body << @div
  end

  after do
    @div.remove
  end

  it "returns true if the element contains the given class name, otherwise false" do
    a = Element.find_by_id('has_class_spec_1')
    a.has_class?('eeeek').should == false

    b = Element.find_by_id('has_class_spec_2')
    b.has_class?('foo').should == true
    b.has_class?('bar').should == false
    b.has_class?('fo').should == false

    c = Element.find_by_id('has_class_spec_3')
    c.has_class?('foo').should == false
  end
end
