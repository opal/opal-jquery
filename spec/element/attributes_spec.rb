describe Element do
  before do
    @div = Document.parse <<-HTML
      <div id="attributes-spec">
        <div id="foo"></div>
        <div id="bar" class="apples"></div>
        <div id="baz" class="lemons"></div>

        <div id="attr-foo" title="Hello there!"></div>
        <div id="attr-bar"></div>
        <div id="attr-baz" title=""></div>
        <div id="attr-woosh"></div>
        <div id="attr-kapow" title="Apples"></div>

        <div id="has-foo" class="apples"></div>
        <div id="has-bar" class="lemons bananas"></div>

        <div id="html-foo">Hey there</div>
        <div id="html-bar"><p>Erm</p></div>

        <div class="html-bridge">Hello</div>
        <div class="html-bridge">Hello as well</div>

        <div id="remove-foo"></div>

        <div id="remove-bar" class="lemons"></div>
        <div id="remove-baz" class="apples oranges"></div>
        <div id="remove-buz" class="pineapples mangos"></div>

        <div id="remove-bleh" class="fruit"></div>

        <select id="value-foo">
          <option selected="selected">Hello</option>
          <option>World</option>
        </select>

        <input id="value-bar" type="text" value="Blah"></input>
        <div id="value-baz"></div>

        <input type="text" id="value-woosh" value=""></input>
      </div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  describe '#[]' do
    it 'should retrieve the attr value from the element' do
      Document.id('attr-foo')[:title].should == "Hello there!"
    end

    it 'should return an empty string for an empty attribute value' do
      Document.id('attr-bar')[:title].should == ""
      Document.id('attr-baz')[:title].should == ""
    end
  end

  describe '#[]=' do
    it 'should set the attr value on the element' do
      woosh = Document.id 'attr-woosh'
      woosh[:title].should == ""

      woosh[:title] = "Oranges"
      woosh[:title].should == "Oranges"
    end

    it 'should replace the old value for the attribute' do
      kapow = Document.id 'attr-kapow'
      kapow[:title].should == "Apples"

      kapow[:title] = "Pineapple"
      kapow[:title].should == "Pineapple"
    end
  end

  describe "#add_class" do
    it "should add the given class name to the element" do
      foo = Document.id 'foo'
      foo.has_class?('lemons').should be_false
      foo.add_class 'lemons'
      foo.has_class?('lemons').should be_true
    end

    it "should not duplicate class names on an element" do
      bar = Document.id 'bar'
      bar.has_class?('apples').should be_true
      bar.add_class 'apples'
      bar.class_name.should == 'apples'
    end

    it "should return self" do
      baz = Document.id 'baz'
      baz.add_class('oranges').should equal(baz)
      baz.add_class('oranges').should equal(baz)
    end
  end

  describe '#has_class?' do
    it "should return true if the element has the given class" do
      Document.id('has-foo').has_class?("apples").should be_true
      Document.id('has-foo').has_class?("oranges").should be_false
      Document.id('has-bar').has_class?("lemons").should be_true
    end
  end

  describe '#html' do
    it "should return the html content of the element" do
      Document.id('html-foo').html.should == "Hey there"
      Document.id('html-bar').html.should == "<p>Erm</p>"
    end

    it "should only return html for first matched element" do
      Document.find('.html-bridge').html.should == "Hello"
    end

    it "should return empty string for empty set" do
      Document.find('.html-nothing-here').html.should == ""
    end
  end

  describe '#remove_class' do
    it "should have no effect on elements without class" do
      foo = Document.id 'remove-foo'
      foo.class_name.should == ''
      foo.remove_class 'blah'
      foo.class_name.should == ''
    end

    it "should remove the given class from the element" do
      bar = Document.id 'remove-bar'
      bar.remove_class "lemons"
      bar.class_name.should == ''

      baz = Document.id 'remove-baz'
      baz.remove_class 'lemons'
      baz.class_name.should == 'apples oranges'

      baz.remove_class 'apples'
      baz.class_name.should == 'oranges'

      buz = Document.id 'remove-buz'
      buz.remove_class 'mangos'
      buz.class_name.should == 'pineapples'

      buz.remove_class 'pineapples'
      buz.class_name.should == ''
    end

    it "should return self" do
      bleh = Document.id 'remove-bleh'
      bleh.remove_class('fruit').should equal(bleh)
      bleh.remove_class('hmmmm').should equal(bleh)
    end
  end

  describe '#toggle_class' do
    it 'adds the given class name to the element if not already present' do
      foo = Document['#foo']
      foo.has_class?('oranges').should be_false
      foo.toggle_class 'oranges'
      foo.has_class?('oranges').should be_true
    end

    it 'removes the class if the element already has it' do
      bar = Document['#bar']
      bar.has_class?('apples').should be_true
      bar.toggle_class 'apples'
      bar.has_class?('apples').should be_false
    end
  end

  describe "#value" do
    it "should return the selected value of select elements" do
      Document.id('value-foo').value.should == "Hello"
    end

    it "should return the value of normal input fields" do
      Document.id('value-bar').value.should == "Blah"
    end

    it "should return an empty string for elements with no value attr" do
      Document.id('value-baz').value.should == ""
    end
  end

  describe "#value=" do
    it "should set the value of the element to the given value" do
      foo = Document.id 'value-woosh'
      foo.value.should == ""

      foo.value = "Hi"
      foo.value.should == "Hi"

      foo.value = "There"
      foo.value.should == "There"
    end
  end
end