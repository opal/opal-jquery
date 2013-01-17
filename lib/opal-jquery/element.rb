# Instances of Element are just jquery instances, and wrap 1 or more
# native dom elements.
class Element < `jQuery`
  def self.find(selector)
    `$(selector)`
  end

  def self.id(id)
    Document.id(id)
  end

  def self.new(tag = 'div')
    `$(document.createElement(tag))`
  end

  def self.parse(str)
    `$(str)`
  end

  def [](name)
    `#{self}.attr(name) || ""`
  end

  alias_native :[]=, :attr

  # Add the given content to inside each element in the receiver. The
  # content may be a HTML string or a `DOM` instance. The inserted
  # content is added to the end of the receiver.
  #
  # @example Given HTML String
  #
  #   DOM.find('ul').append '<li>list content</li>'
  #
  # @example Given an existing DOM node
  #
  #   DOM.id('checkout') << Dom.id('total-price-label')
  #
  # @param [String, DOM] content HTML string or DOM content
  # @return [DOM] returns receiver
  alias_native :<<, :append

  alias_native :add_class, :addClass

  # Add the given content after each element in the receiver. The given
  # content may be a HTML string, or a `DOM` instance.
  #
  # @example Given HTML String
  #
  #   DOM.find('.label').after '<p>Content after label</>'
  #
  # @example Given existing DOM nodes
  #
  #   DOM.find('.price').after DOM.id('checkout-link')
  #
  # @param [String, DOM] content HTML string or dom content
  # @return [DOM] returns self
  alias_native :after, :after

  alias append <<

  # Appends the elements in #{self} object into the target element. #{self}
  # method is the reverse of using `#append` on the target with #{self}
  # instance as the argument.
  #
  # @example
  #
  #   DOM.parse('<p>Hello</p>').append_to DOM.id('foo')
  #
  # @param [DOM] target the target to insert into
  # @return [DOM] returns the receiver
  alias_native :append_to, :appendTo

  def append_to_body
    `#{self}.appendTo(document.body)`
  end

  def append_to_head
    `#{self}.appendTo(document.head)`
  end

  # Returns the element at the given index as a new `DOM` instance.
  # Negative indexes can be used and are counted from the end. If the
  # given index is outside the range then `nil` is returned.
  #
  # @example
  #
  #   DOM('.foo')[0]    # => first element in collection
  #   DOM('.foo')[-1]   # => last element from collection
  #   DOM('.foo')[100]  # => returns nil if index outside range
  #
  # @param [Numeric] index the index to get
  # @return [DOM, nil] returns new collection with returned element
  def at(index)
    %x{
      var length = #{self}.length;

      if (index < 0) {
        index += length;
      }

      if (index < 0 || index >= length) {
        return nil;
      }

      return $(#{self}[index]);
    }
  end

  # Insert the given content into the DOM before each element in #{self}
  # collection. The content may be a raw HTML string or a `DOM`
  # instance containing elements.
  #
  # @example
  #
  #   # Given a string
  #   DOM('.foo').before '<p class="title"></p>'
  #
  #   # Using an existing element
  #   DOM('.bar').before DOM('#other-title')
  #
  # @param [DOM, String] content the content to insert before
  # @return [DOM] returns the receiver
  alias_native :before, :before

  # Returns a new collection containing the immediate children of each
  # element in #{self} collection. The result may be empty if no children
  # are present.
  #
  # @example
  #
  #   DOM('#foo').children  # => DOM instance
  #
  # @return [DOM] returns new DOM collection
  alias_native :children, :children

  # Returns the CSS class name of the firt element in #{self} collection.
  # If the collection is empty then an empty string is returned. Only
  # the class name of the first element will ever be returned.
  #
  # @example
  #
  #   DOM('<p class="foo"></p>').class_name
  #   # => "foo"
  #
  # @return [String] the class name
  def class_name
    %x{
      var first = #{self}[0];

      if (!first) {
        return "";
      }

      return first.className || "";
    }
  end

  # Sets the CSS class name of every element in #{self} collection to the
  # given string. #{self} does not append the class names, it replaces
  # the entire current class name.
  #
  # @example
  #
  #   DOM('#foo').class_name = "title"
  #
  # @param [String] name the class name to set on each element
  # @return [DOM] returns the receiver
  def class_name=(name)
    %x{
      for (var i = 0, length = #{self}.length; i < length; i++) {
        #{self}[i].className = name;
      }
    }
    self
  end

  # Get or set css properties on each element in #{self} collection. If
  # only the `name` is given, then that css property name is read from
  # the first element in the collection and returned. If the `value`
  # property is also given then the given css property is set to the
  # given value for each of the elements in #{self} collection. The
  # property can also be a hash of properties and values.
  #
  # @example
  #
  #   foo = DOM '#foo'
  #   foo.css 'background-color'            # => "red"
  #   foo.css 'background-color', 'green'
  #   foo.css 'background-color'            # => "green"
  #   foo.css :width => '200px'
  #
  # @param [String] name the css property to get/set
  # @param [String] value optional value to set
  # @param [Hash] set of css properties and values
  # @return [String, DOM] returns css value or the receiver
  def css(name, value=nil)
    if value.nil? && name.is_a?(String)
      return `$(#{self}).css(name)`
    else
      name.is_a?(Hash) ? `$(#{self}).css(#{name.to_native})` : `$(#{self}).css(name, value)`
    end
    self
  end
  
  # Set css values over time to create animations. The first parameter is a
  # set of css properties and values to animate to. The first parameter
  # also accepts a special :speed value to set animation speed. If a block
  # is given, the block is run as a callback when the animation finishes.
  #
  # @example
  #
  #   foo = DOM "#foo"
  #   foo.animate :height => "200px", "margin-left" => "10px"
  #   bar.animate :top => "30px", :speed => 100 do
  #     bar.add_class "finished"
  #   end
  # 
  # @param [Hash] css properties and and values. Also accepts speed param.
  # @return [DOM] receiver
  def animate(params, &block)
    speed = params.has_key?(:speed) ? params.delete(:speed) : 400
    %x{
      $(#{self}).animate(#{params.to_native}, #{speed}, function() {
        #{block.call if block_given?}
      })
    } 
  end

  # Yields each element in #{self} collection in turn. The yielded element
  # is wrapped as a `DOM` instance.
  #
  # @example
  #
  #   DOM('.foo').each { |e| puts "The element id: #{e.id}" }
  #
  # @return returns the receiver
  def each
    `for (var i = 0, length = #{self}.length; i < length; i++) {`
      yield `$(#{self}[i])`
    `}`
    self
  end

  # return an opal array mapped with block yielded for any element 
  #
  # @example
  #
  #  list = Document.find('table.players td.surname').map  {|el| el.html } 
  #
  # @return an Array
  def map
    list = []
    each {|el| list << yield(el) }
    list
  end

  # return an opal Array of elements
  #
  # @example
  #
  # Document.find('table.players td.surname').to_a.last
  #
  # @return an Array
  def to_a
    map {|el| el }
  end

  # Find all the elements that match the given `selector` within the
  # scope of elements in #{self} given collection. Might return an empty
  # collection if no elements match.
  #
  # @example
  #
  #   form = DOM('#login-form')
  #   form.find 'input, select'
  #
  # @param [String] selector the selector to match elements against
  # @return [DOM] returns new collection
  alias_native :find, :find

  def first
    `#{self}.length ? #{self}.first() : nil`
  end

  alias_native :focus, :focus

  alias_native :has_class?, :hasClass

  def html
    `#{self}.html() || ""`
  end

  alias_native :html=, :html

  def id
    %x{
      var first = #{self}[0];

      if (!first) {
        return "";
      }

      return first.id || "";
    }
  end

  def id=(id)
    %x{
      var first = #{self}[0];

      if (first) {
        first.id = id;
      }

      return #{self};
    }
  end

  def inspect
    %x{
      var val, el, str, result = [];

      for (var i = 0, length = #{self}.length; i < length; i++) {
        el  = #{self}[i];
        str = "<" + el.tagName.toLowerCase();

        if (val = el.id) str += (' id="' + val + '"');
        if (val = el.className) str += (' class="' + val + '"');

        result.push(str + '>');
      }

      return '[' + result.join(', ') + ']';
    }
  end

  def length
    `#{self}.length`
  end

  alias_native :next, :next

  alias_native :siblings, :siblings

  def off(event_name, selector, handler=nil)
    %x{
      if (handler === nil) {
        handler = selector;
        #{self}.off(event_name, handler._jq);
      }
      else {
        #{self}.off(event_name, selector, handler._jq);
      }
    }
    
    handler
  end

  def on(event_name, selector=nil, &block)
    return unless block_given?

    # The choice of allowing a maximum of four parameters is arbitrary.  arg1 is typically the
    # event object and the rest are parameters passed by trigger().  For example, Rails 3 AJAX
    # event handlers get passed up to three additional parameters in addition to the event object.
    %x{
      var handler = function(arg1, arg2, arg3, arg4) {
        return #{ block.call `arg1, arg2, arg3, arg4` }
      };
      block._jq = handler;

      if (selector === nil) {
        #{self}.on(event_name, handler);
      }
      else {
        #{self}.on(event_name, selector, handler);
      }
    }

    block
  end

  alias_native :parent, :parent

  alias_native :prev, :prev

  alias_native :remove, :remove

  alias_native :remove_class, :removeClass

  alias size length

  alias succ next

  alias_native :text=, :text

  alias_native :toggle_class, :toggleClass

  alias_native :trigger, :trigger

  def value
    `#{self}.val() || ""`
  end

  alias_native :value=, :val

  # display functions
  alias_native :hide, :hide
  alias_native :show, :show
  alias_native :toggle, :toggle
end
