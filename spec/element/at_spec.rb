describe "Element#at" do
  before do
    @div = Document.parse <<-HTML
      <div id="at-spec">
        <div class="foo" id="blah"></div>
        <div class="foo" id="bleh"></div>
        <div class="foo" id="bluh"></div>
      </div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "returns the element at the given index" do
    foos = Document.find '.foo'
    foos.length.should == 3

    foos.at(0).id.should == "blah"
    foos.at(1).id.should == "bleh"
    foos.at(2).id.should == "bluh"
  end

  it "counts from the last index for negative values" do
    foos = Document.find '.foo'

    foos.at(-1).id.should == "bluh"
    foos.at(-2).id.should == "bleh"
    foos.at(-3).id.should == "blah"
  end

  it "returns nil for indexes outside range" do
    foos = Document.find '.foo'

    foos.at(-4).should == nil
    foos.at(4).should == nil
  end
end