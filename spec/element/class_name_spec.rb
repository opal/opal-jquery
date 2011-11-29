require File.expand_path('../../spec_helper', __FILE__)

describe "Element#class_name" do
  before do
    @div = Element.new :div
    @div.html = <<-HTML
      <div id="class_name1"></div>
      <div id="class_name2" class="foo"></div>
    HTML

    Element.body << @div
  end

  after do
    @div.remove
  end

  it "returns the class name for the receiver" do
    Element.query('#class_name1').class_name.should == ""
    Element.query('#class_name2').class_name.should == "foo"
  end
end
