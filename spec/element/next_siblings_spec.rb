require File.expand_path('../../spec_helper', __FILE__)

describe "Element#next_siblings" do
  before do
    @div = Element.new :div
    @div.id = :next_siblings_spec
    @div.html = <<-HTML
      <p id="a"></p>
      <p id="b">
        <span></span>
      </p>
      <p id="c"></p>
      <p id="d"></p>
    HTML

    Element.body << @div

    @p_a = Element.query '#a'
    @p_b = Element.query '#b'
    @p_c = Element.query '#c'
    @p_d = Element.query '#d'
  end

  after do
    @div.remove
  end

  it "should return the elements next siblings" do
    @p_b.next_siblings.should == [@p_c, @p_d]
    @p_c.next_siblings.should == [@p_d]
  end

  it "should return an empty array for elements without next siblings" do
    @p_d.next_siblings.should == []
  end

  it "should only return next siblings, not children or previous siblings" do
    @p_a.next_siblings.should == [@p_b, @p_c, @p_d]
  end
end
