require "spec_helper"

describe Event do
  html <<-HTML
    <div id="on-spec">
      <div id="foo">
        <div id="bar"></div>
      </div>
      <div id="baz"></div>
    </div>
  HTML

  it '#current_target returns the current element in the bubbling' do
    foo = Document['#foo']
    bar = Document['#bar']
    result = []

    foo.on(:click) { |e| result << e.current_target.id }
    bar.on(:click) { |e| result << e.current_target.id }

    foo.trigger(:click)
    result.should == ['foo']
    result = []

    bar.trigger(:click)
    result.should == ['bar', 'foo']
  end

  it '#type returns the type of event' do
    type = nil
    foo  = Document['#foo']

    foo.on(:click) { |e| type = e.type }
    foo.on(:mousedown) { |e| type = e.type }
    foo.on(:opal_random) { |e| type = e.type }

    foo.trigger(:click)
    type.should == :click

    foo.trigger(:mousedown)
    type.should == :mousedown

    foo.trigger(:opal_random)
    type.should == :opal_random
  end

  it '#target returns a JQuery wrapper around the element that triggered the event' do
    foo = Document['#foo']
    bar = Document['#bar']
    target = nil

    foo.on(:click) { |e| target = e.target.id }

    foo.trigger(:click)
    target.should == 'foo'

    bar.trigger(:click)
    target.should == 'bar'
  end
end
