%x{
  var fn;

  if (typeof(jQuery) !== 'undefined') {
    fn = jQuery;
  }
  else if (typeof(Zepto) !== 'undefined') {
    fn = Zepto.fn.constructor;
  }
  else {
    #{ raise "no DOM library found"};
  }
}

class JQuery < `fn`
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
  # given value for each of the elements in #{self} collection.
  #
  # @example
  #
  #   foo = DOM '#foo'
  #   foo.css 'background-color'            # => "red"
  #   foo.css 'background-color', 'green'
  #   foo.css 'background-color'            # => "green"
  #
  # @param [String] name the css property to get/set
  # @param [String] value optional value to set
  # @return [String, DOM] returns css value or the receiver
  alias_native :css, :css

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

      return '(' + result.join(', ') + ')';
    }
  end

  def length
    `#{self}.length`
  end

  alias_native :next, :next

  def on(name, &block)
    return unless block_given?

    %x{
      #{self}.on(name, function() {
        return #{ block.call };
      });
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

  def value
    `#{self}.val() || ""`
  end

  alias_native :value=, :val
end