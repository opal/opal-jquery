require "spec_helper"

describe Window do
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

      Window.on(:click) { count += 1 }
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

      Window.on(:click, '#bar') { count += 1 }
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

      Window.on('opal-is-mega-lolz') { count += 1 }
      count.should == 0
      Window.trigger('opal-is-mega-lolz')
      count.should == 1
      Window.trigger('opal-is-mega-lolz')
      count.should == 2
    end

    it 'returns the given handler' do
      handler = proc {}
      Window.on(:click, &handler).should == handler
    end

###
    it 'has an Event instance passed to the handler' do
      foo = Element['#foo']
      Window.on :click do |event|
        event.should be_kind_of(Event)
      end
      foo.trigger(:click)
    end

    it 'has an Event instance, plus any additional parameters passed to the handler' do
      foo = Element['#foo']
      Window.on :bozo do |event, foo, bar, baz, buz|
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

      handler = Window.on(:click) { count += 1 }
      count.should == 0
      foo.trigger(:click)
      count.should == 1
      Window.off(:click, handler)
      count.should == 1
      foo.trigger(:click)
      count.should == 1
    end

    it 'removes event handlers added with a selector' do
      count = 0
      bar   = Element['#bar']

      handler = Window.on(:click, '#bar') { count += 1 }
      count.should == 0
      bar.trigger(:click)
      count.should == 1
      Window.off(:click, '#bar', handler)
      count.should == 1
      bar.trigger(:click)
      count.should == 1
    end
  end

  pending '#width'

  pending '#height'
end
