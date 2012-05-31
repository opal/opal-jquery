describe "Element#each" do
  before do
    @div = Element.new

    @div.id = 'each-spec'
    @div.html = <<-HTML
      <div class="foo" id="each-a"></div>
      <div class="bar" id="each-b"></div>
      <div class="foo" id="each-c"></div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should loop over each element passing element to block" do
    result = []
    Element.find('.foo').each do |e|
      result << e.id
    end

    result.should == ['each-a', 'each-c']
  end

  it "should not call the block with an empty element set" do
    Element.find('.bad-each-class').each do
      raise "shouldn't get here"
    end
  end
end