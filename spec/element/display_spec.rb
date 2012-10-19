describe "Element display methods" do
  before do
    @div = Document.parse <<-HTML
      <div id="css-spec">
        <div id="shown"></div>
        <div id="hidden" style="display: none"></div>
      </div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  it "hides an element" do
    element = Document.id('shown') 
    element.css('display').should == 'block'
    element.hide
    element.css('display').should == 'none'
  end

  it "shows an element" do 
    element = Document.id('hidden') 
    element.css('display').should == 'none'
    element.show
    element.css('display').should == 'block'
  end

  it "toggles on a hidden element" do
    element = Document.id('hidden') 
    element.css('display').should == 'none'
    element.toggle
    element.css('display').should == 'block'
  end

  it "toggles off a displayed element" do
    element = Document.id('shown') 
    element.css('display').should == 'block'
    element.toggle
    element.css('display').should == 'none'
  end
  
end
