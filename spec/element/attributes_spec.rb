require "spec_helper"

describe Element do
  html <<-HTML
    <div id="foo"></div>
    <div id="bar" class="apples"></div>
    <div id="baz" class="lemons"></div>

    <div id="attr-foo" title="Hello there!"></div>
    <div id="attr-bar"></div>
    <div id="attr-baz" title=""></div>
    <div id="attr-woosh"></div>
    <div id="attr-kapow" title="Apples"></div>
    <div id="attr-empty" attr-empty-value=""></div>
    <div id="attr-missing" attr-auto-value></div>

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
  HTML

  describe '#[]' do
    it 'should retrieve the attr value from the element' do
      Element.find('#attr-foo')[:title].should == "Hello there!"
    end

    it 'should return nil for a missing attribute' do
      expect(Element.find('#attr-missing')['attr-missing-value']).to be_nil
    end

    it 'should return "" for an attribute with empty value' do
      expect(Element.find('#attr-empty')['attr-empty-value']).to eq("")

      # Not sure if this is browser dependant
      expect(Element.find('#attr-missing')['attr-auto-value']).to eq("")
    end
  end

  describe '#attr' do
    it 'returns attributes from elements' do
      expect(Element.find('#attr-foo').attr(:title)).to eq('Hello there!')
    end

    it 'should return nil for a missing attribute' do
      expect(Element.find('#attr-missing').attr('attr-missing-value')).to be_nil
    end

    it 'should return "" for an attribute with empty value' do
      expect(Element.find('#attr-empty').attr('attr-empty-value')).to eq("")

      # Not sure if this is browser dependant
      expect(Element.find('#attr-missing').attr('attr-auto-value')).to eq("")
    end
  end

  describe '#[]=' do
    it 'should set the attr value on the element' do
      woosh = Element.find '#attr-woosh'
      expect(woosh[:title]).to be_nil

      woosh[:title] = "Oranges"
      expect(woosh[:title]).to eq('Oranges')
    end

    it 'should replace the old value for the attribute' do
      kapow = Element.find '#attr-kapow'
      kapow[:title].should == "Apples"

      kapow[:title] = "Pineapple"
      kapow[:title].should == "Pineapple"
    end
  end

  describe "#add_class" do
    it "should add the given class name to the element" do
      foo = Element.find '#foo'
      expect(foo).to_not have_class('lemons')

      foo.add_class 'lemons'
      expect(foo).to have_class('lemons')
    end

    it "should not duplicate class names on an element" do
      bar = Element.find '#bar'
      expect(bar).to have_class('apples')

      bar.add_class 'apples'
      expect(bar.class_name).to eq('apples')
    end

    it "should return self" do
      baz = Element.find '#baz'
      expect(baz.add_class('oranges')).to eq(baz)
    end
  end

  describe '#has_class?' do
    it "should return true if the element has the given class" do
      expect(Element.find('#has-foo')).to have_class('apples')
      expect(Element.find('#has-bar')).to have_class('lemons')

      expect(Element.find('#has-foo')).to_not have_class('oranges')
    end
  end

  describe '#html' do
    it "should return the html content of the element" do
      Element.find('#html-foo').html.should == "Hey there"
      Element.find('#html-bar').html.downcase.should == "<p>erm</p>"
    end

    it "should only return html for first matched element" do
      Element.find('.html-bridge').html.should == "Hello"
    end

    it "should return empty string for empty set" do
      Element.find('.html-nothing-here').html.should == ""
    end
  end

  describe '#remove_class' do
    it "should have no effect on elements without class" do
      foo = Element.find '#remove-foo'
      foo.class_name.should == ''
      foo.remove_class 'blah'
      foo.class_name.should == ''
    end

    it "should remove the given class from the element" do
      bar = Element.find '#remove-bar'
      bar.remove_class "lemons"
      bar.class_name.should == ''

      baz = Element.find '#remove-baz'
      baz.remove_class 'lemons'
      baz.class_name.should == 'apples oranges'

      baz.remove_class 'apples'
      baz.class_name.should == 'oranges'

      buz = Element.find '#remove-buz'
      buz.remove_class 'mangos'
      buz.class_name.should == 'pineapples'

      buz.remove_class 'pineapples'
      buz.class_name.should == ''
    end

    it "should return self" do
      bleh = Element.find '#remove-bleh'
      bleh.remove_class('fruit').should equal(bleh)
      bleh.remove_class('hmmmm').should equal(bleh)
    end
  end

  describe '#toggle_class' do
    it 'adds the given class name to the element if not already present' do
      foo = Element.find('#foo')
      foo.has_class?('oranges').should eq(false)
      foo.toggle_class 'oranges'
      foo.has_class?('oranges').should eq(true)
    end

    it 'removes the class if the element already has it' do
      bar = Element.find('#bar')
      bar.has_class?('apples').should eq(true)
      bar.toggle_class 'apples'
      bar.has_class?('apples').should eq(false)
    end
  end

  describe "#value" do
    it "should return the selected value of select elements" do
      Element.find('#value-foo').value.should == "Hello"
    end

    it "should return the value of normal input fields" do
      Element.find('#value-bar').value.should == "Blah"
    end

    it "should return an empty string for elements with no value attr" do
      Element.find('#value-baz').value.should == ""
    end
  end

  describe "#value=" do
    it "should set the value of the element to the given value" do
      foo = Element.find '#value-woosh'
      foo.value.should == ""

      foo.value = "Hi"
      foo.value.should == "Hi"

      foo.value = "There"
      foo.value.should == "There"
    end
  end
end
