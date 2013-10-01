require "spec_helper"

describe "Element display methods" do
  html <<-HTML
    <div id="shown"></div>
    <div id="hidden" style="display: none"></div>
  HTML

  it "hides an element" do
    element = Element.find('#shown') 
    element.css('display').should == 'block'
    element.hide
    element.css('display').should == 'none'
  end

  it "shows an element" do 
    element = Element.find('#hidden') 
    element.css('display').should == 'none'
    element.show
    element.css('display').should == 'block'
  end

  it "toggles on a hidden element" do
    element = Element.find('#hidden') 
    element.css('display').should == 'none'
    element.toggle
    element.css('display').should == 'block'
  end

  it "toggles off a displayed element" do
    element = Element.find('#shown') 
    element.css('display').should == 'block'
    element.toggle
    element.css('display').should == 'none'
  end
end
