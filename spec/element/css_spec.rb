require "spec_helper"

RSpec.describe "Element#css" do
  html <<-HTML
    <div id="foo" style="background-color:rgb(15,99,30); color:;"></div>
    <div id="bar"></div>
    <div id="hash"></div>
  HTML

  describe "with a given name" do
    it "returns the value of the CSS property for the given name" do
      Element.find('#foo').css('backgroundColor').should be_kind_of(String)
    end

    it "should return an empty string when no style property is defined for name" do
      Element.find('#foo').css('color').should be_kind_of(String)
    end
  end

  describe "with a name and value" do
    it "should set the CSS property to the given value" do
      Element.find('#bar').css('backgroundColor', 'blue')
    end

    it "returns self" do
      bar = Element.find('#bar')
      bar.css("background", "green").should equal(bar)
    end
  end

  describe "with a set of names and values" do
    it "should set the properties" do
      hash = Element.find("#hash")
      hash.css(:width => "100px", :height => "200px")
      hash.css("width").should be_kind_of(String)
      hash.css("height").should be_kind_of(String)
    end

    it "should return self" do
      hash = Element.find("#hash")
      hash.css(:border => "1px solid #000").should equal(hash)
    end
  end
end
