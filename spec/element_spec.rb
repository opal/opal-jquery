require "spec_helper"

RSpec.describe Element do
  context 'events' do
    html <<-HTML
      <div id="foo">
        <div id="bar" class="apples"></div>
      </div>
      <div id="baz"></div>
    HTML

    describe '#on' do
      it 'adds an event listener onto the elements' do
        count = 0
        foo   = Element['#foo']

        foo.on(:click) { count += 1 }
        count.should == 0
        foo.trigger(:click)
        count.should == 1
        foo.trigger(:click)
        count.should == 2
        foo.trigger(:mousedown)
        count.should == 2
      end

      it 'takes an optional second parameter to delegate events' do
        count = 0
        foo   = Element['#foo']
        bar   = Element['#bar']

        foo.on(:click, '#bar') { count += 1 }
        count.should == 0
        foo.trigger(:click)
        count.should == 0
        bar.trigger(:click)
        count.should == 1
        bar.trigger(:click)
        count.should == 2
        bar.trigger(:mousedown)
        count.should == 2
      end

      it 'can listen for non-browser events' do
        count = 0
        foo   = Element['#foo']

        foo.on('opal-is-mega-lolz') { count += 1 }
        count.should == 0
        foo.trigger('opal-is-mega-lolz')
        count.should == 1
        foo.trigger('opal-is-mega-lolz')
        count.should == 2
      end

      it 'returns the given handler' do
        handler = proc {}
        Element['#foo'].on(:click, &handler).should == handler
      end

      it 'has an Event instance passed to the handler' do
        foo = Element['#foo']
        foo.on :click do |event|
          event.should be_kind_of(Event)
        end
        foo.trigger(:click)
      end

      it 'has an Event instance, plus any additional parameters passed to the handler' do
        foo = Element['#foo']
        foo.on :bozo do |event, foo, bar, baz, buz|
          event.should be_kind_of(Event)
          foo.should == 'foo'
          bar.should == 'bar'
          baz.should == 'baz'
          buz.should == 'buz'
        end
        foo.trigger(:bozo, ['foo', 'bar', 'baz', 'buz'])
      end
    end

    describe '#off' do
      it 'removes event handlers that were added using #on' do
        count = 0
        foo   = Element['#foo']

        handler = foo.on(:click) { count += 1 }
        count.should == 0
        foo.trigger(:click)
        count.should == 1
        foo.off(:click, handler)
        count.should == 1
        foo.trigger(:click)
        count.should == 1
      end

      it 'removes event handlers added with a selector' do
        count = 0
        foo   = Element['#foo']
        bar   = Element['#bar']

        handler = foo.on(:click, '#bar') { count += 1 }
        count.should == 0
        bar.trigger(:click)
        count.should == 1
        foo.off(:click, '#bar', handler)
        count.should == 1
        bar.trigger(:click)
        count.should == 1
      end
    end
  end

  context 'selectors/parse' do
    html <<-HTML
      <div id="foo" class="bar"></div>
      <div class="woosh"></div>
      <div class="woosh"></div>
      <div class="find-foo"></div>
      <div class="find-bar"></div>
      <div class="find-foo"></div>
    HTML

    describe ".[]" do
      it "should be able to find elements with given id" do
        Element['#foo'].class_name.should == "bar"
        Element['#foo'].size.should == 1
      end

      it "should be able to match any valid CSS selector" do
        Element['.woosh'].should be_kind_of(Element)
        Element['.woosh'].size.should == 2
      end

      it "should return an empty Elements instance when not matching any elements" do
        dom = Element['.some-non-existing-class']

        dom.should be_kind_of(Element)
        dom.size.should == 0
      end

      it "should accept an HTML string and parse it into a Elements instance" do
        el = Element['<div id="foo-bar-baz"></div>']

        el.should be_kind_of(Element)
        el.id.should == "foo-bar-baz"
        el.size.should == 1
      end
    end

    describe ".find" do
      it "should find all elements matching CSS selector" do
        foo = Element.find '.find-foo'
        foo.should be_kind_of(Element)
        foo.length.should == 2

        bar = Element.find '.find-bar'
        bar.should be_kind_of(Element)
        bar.length.should == 1
      end

      it "should return an empty Element instance with length 0 when no matching" do
        baz = Element.find '.find-baz'
        baz.should be_kind_of(Element)
        baz.length.should == 0
      end
    end

    describe ".not" do
      it "should subtract from a set of elements" do
        divs = Element['#foo, .woosh']
        divs.should be_kind_of(Element)
        divs.size.should == 3

        subtracted = divs.not('#foo')
        subtracted.should be_kind_of(Element)
        subtracted.length.should == 2
      end
    end

    describe '.id' do
      it "should return a new instance with the element with given id" do
        Element.id('foo').should be_kind_of(Element)
        Element.id('foo').id.should == 'foo'
      end

      it "should return nil if no element could be found" do
        Element.id('bad-element-id').should be_nil
      end
    end

    describe '.parse' do
      it "should return a new instance with parsed element as single element" do
        foo = Element.parse '<div id="foo" class="bar"></div>'
        foo.id.should == 'foo'
        foo.class_name.should == 'bar'
      end
    end

  end

  describe "#data" do
    html <<-HTML
      <div id="data-foo"></div>
      <div id="data-ford" data-authur="dent" data-baz="bar"></div>
    HTML

    it "sets a data attribute" do
      foo = Element.id('data-foo')
      foo.data 'bar', 'baz'
      expect(foo.data('bar')).to eq('baz')
    end

    it "can retrieve a data attribute" do
      expect(Element.id('data-ford').data('authur')).to eq('dent')
    end

    it "can retrieve all data attributes" do
      expect(Element.id('data-ford').data).to eq(
        'authur' => 'dent', 'baz' => 'bar'
      )
    end

    it "returns nil for an undefined data attribute" do
      expect(Element.id('data-ford').data('not-here')).to be_nil
    end
  end

  describe "#html" do
    html <<-HTML
      <div id="foo">bar</div>
    HTML

    it "retrieves the inner html content for the element" do
      expect(Element.id('foo').html).to include('bar')
    end

    it "can be used to set inner html of element by passing string" do
      foo = Element.id 'foo'
      foo.html "different content"

      expect(foo.html).to_not include('bar')
      expect(foo.html).to include('different content')
    end
  end

  describe '.expose' do
    subject(:element) { Element.new }
    before do
      `$.fn.exposableMethod = function() {return 123}`
      `$.fn.exposableMethod2 = function() {return 12}`
    end

    after do
      `delete $.fn.exposableMethod; delete $.fn.$exposableMethod;`
      `delete $.fn.exposableMethod2; delete $.fn.$exposableMethod2;`
    end

    it 'exposes methods defined on $.fn' do
      expect(element).not_to respond_to(:exposableMethod)
      Element.expose :exposableMethod
      expect(element).to respond_to(:exposableMethod)
      expect(element.exposableMethod).to eq(123)
    end

    it 'work if exposing the same method multiple times' do
      Element.expose :exposableMethod
      Element.expose :exposableMethod
      expect(element.exposableMethod).to eq(123)

      Element.expose :exposableMethod, :exposableMethod
      expect(element.exposableMethod).to eq(123)
    end

    it 'work if exposing multiple methods' do
      Element.expose :exposableMethod, :exposableMethod2
      expect(element.exposableMethod).to eq(123)
      expect(element.exposableMethod2).to eq(12)
    end
  end

  describe '#prop' do
    it 'converts nil to null' do
      checkbox = Element.new(:input).attr(:type, :checkbox)

      checkbox.prop(:checked, nil)
      expect(checkbox.prop(:checked)).to be false
    end
  end

  describe '#==' do
    it 'uses .is()' do
      expect(Element['body']).to eq(Element['body'])
    end
  end
end
