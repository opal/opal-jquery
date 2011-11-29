require File.expand_path('../../spec_helper', __FILE__)

describe "Element#remove_class" do
  before do
    @div = Element.new :div
    @div.html = <<-HTML
      <div id="remove_class1"></div>
      <div id="remove_class2" class="foo"></div>
    HTML

    Element.body << @div
  end

  after do
    @div.remove
  end

  it "removes the given class from the receiver" do
    a = Element.query '#remove_class2'
    a.has_class?('foo').should be_true
    a.remove_class('foo')
    a.has_class?('foo').should be_false
  end

  it "returns self" do
    a = Element.query('#remove_class2')
    a.remove_class('ksksksks').should equal(a)
  end
end
