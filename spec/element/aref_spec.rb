require File.expand_path('../../spec_helper', __FILE__)

describe "Element#[]" do
  before do
    @div = Element.new :div
    @div.html = <<-HTML
      <div id="aref_spec_1" onclick="alert('foo');"></div>
      <a id="aref_spec_2" href='bar.html' title='click me'></a>
    HTML

    Element.body << @div
  end

  after do
    @div.remove
  end

  it "should return present attributes using the given name" do
    a = Element.find_by_id('aref_spec_1')
    a['onclick'].should == "alert('foo');"

    b = Element.find_by_id('aref_spec_2')
    b['href'].should == 'bar.html'
    b['title'].should == 'click me'
  end

  it "should except both string and symbol values" do
    b = Element.find_by_id('aref_spec_2')
    b['href'].should == 'bar.html'
    b[:href].should == 'bar.html'
  end

  it "should return nil when the element does not have the given attribute" do
    a = Element.find_by_id('aref_spec_1')
    a['href'].should == nil
    a[:href].should == nil

    a['onmousedown'].should == nil
    a[:onmousedown].should == nil
  end
end
