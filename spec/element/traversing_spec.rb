describe Element do
  before do
    @div = Document.parse <<-HTML
      <div id="traversing-spec">
        <div id="foo" class="traversing-class"></div>
        <div id="bar" class="traversing-class">
          <p>Hey</p>
          <p>There</p>
        </div>
        <div id="baz" class="main-content-wrapper">
          <div><p></p></div>
        </div>
      </div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  describe '#children' do
    it "should return a new collection of all direct children of element" do
      Document.id('foo').children.size.should == 0
      Document.id('bar').children.size.should == 2
    end

    it "should only return direct children" do
      c = Document.id('baz').children
      c.size.should == 1
    end
  end

  describe '#each' do
    it "should loop over each element passing element to block" do
      result = []
      Document.find('.traversing-class').each do |e|
        result << e.id
      end

      result.should == ['foo', 'bar']
    end

    it "should not call the block with an empty element set" do
      Document.find('.bad-each-class').each do
        raise "shouldn't get here"
      end
    end
  end

  describe '#find' do
    it "should match all elements within scope of receiver" do
      foo = Document['#traversing-spec']
      foo.find('.traversing-class').size.should == 2
      foo.find('.main-content-wrapper').size.should == 1
    end

    it "should return an empty collection if there are no matching elements" do
      bar = Document['#bar']
      bar.find('.some-non-existant-class').size.should == 0
    end
  end

  describe '#first' do
    it "should return the first element in the receiver" do
      Document.find('.traversing-class').first.id.should == 'foo'
      Document.id('baz').first.id.should == 'baz'
    end

    it "should return nil when receiver has no elements" do
      Document.find('.some-random-class').first.should == nil
    end
  end
end

describe "Element#next" do
  before do
    @div = Document.parse <<-HTML
      <div id="next-spec">
        <div id="foo"></div>
        <div id="bar"></div>
      </div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should return the next sibling" do
    Document.id('foo').next.id.should == "bar"
  end

  it "should return an empty instance when no next element" do
    Document.id('bar').next.size.should == 0
  end
end

describe "Element#parent" do
  before do
    @div = Document.parse <<-HTML
      <div id="foo">
        <div id="bar">
          <div id="baz"></div>
          <div id="buz"></div>
        </div>
      </div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should return the parent of the element" do
    Document.id('bar').parent.id.should == "foo"
    Document.id('baz').parent.id.should == "bar"
    Document.id('buz').parent.id.should == "bar"
  end
end

describe "Element#succ" do
  before do
    @div = Document.parse <<-HTML
      <div id="succ-spec">
        <div id="foo"></div>
        <div id="bar"></div>
      </div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should return the next sibling" do
    Document.id('foo').succ.id.should == "bar"
  end

  it "should return an empty instance when no next element" do
    Document.id('bar').succ.size.should == 0
  end
end

describe "Element#siblings" do
  before do
    @div = Document.parse <<-HTML
      <div id="siblings-spec">
        <div>
          <div id="foo"></div>
          <div id="bar"></div>
          <div id="baz" class="special"></div>
        </div>
        <div>
          <div id="uno"></div>
        </div>
      </div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "should return all siblings" do
    Document.id('bar').siblings.size.should == 2
    Document.id('bar').siblings.at(0).id.should == "foo"
    Document.id('bar').siblings.at(1).id.should == "baz"
  end

  it "should return all siblings that match the selector" do
    Document.id('bar').siblings('.special').size.should == 1
    Document.id('bar').siblings('.special').at(0).id.should == "baz"
  end

  it "should return an empty instance when there are no siblings" do
    Document.id('uno').siblings.size.should == 0
  end
end
