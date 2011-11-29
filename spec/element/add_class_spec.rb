require File.expand_path('../../spec_helper', __FILE__)

describe "Element#add_class" do
  before do
    @div = Element.new :div
    @div.html = <<-HTML
      <div id="add_class1"></div>
      <div id="add_class2" class="bar"></div>
    HTML

    Element.body << @div
  end

  after do
    @div.remove
  end

  it "adds the given class to the receivers class list" do
    a = Element.query '#add_class1'
    a.has_class?('foo').should == false
    a.add_class('foo')
    a.has_class?('foo').should == true
  end

  it "does not modify class if reciever already has class name" do
    a = Element.query '#add_class2'
    a.has_class?('bar').should == true
    a.add_class('bar')
    a.has_class?('bar').should == true
  end

  it "returns self" do
    a = Element.query('#add_class1')
    b = Element.query('#add_class2')

    a.add_class('foo').should equal(a)
    b.add_class('bar').should equal(b)
  end
end
