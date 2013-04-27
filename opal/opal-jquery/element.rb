# Instances of Element are just jquery instances, and wrap 1 or more
# native dom elements.
class Element < `jQuery`
  def self.find(selector)
    `$(#{selector})`
  end

  def self.id(id)
    %x{
      var el = document.getElementById(id);

      if (!el) {
        return nil;
      }

      return $(el);
    }
  end

  def self.new(tag = 'div')
    `$(document.createElement(tag))`
  end

  def self.parse(str)
    `$(str)`
  end

  def self.expose(*methods)
    %x{
      for (var i = 0, length = methods.length, method; i < length; i++) {
        method = methods[i];
        #{self}.prototype['$' + method] = #{self}.prototype[method];
      }

      return nil;
    }
  end

  expose :after, :before, :parent, :parents, :prepend, :prev, :remove
  expose :hide, :show, :toggle, :children, :blur, :closest, :data
  expose :focus, :find, :next, :siblings, :text, :trigger, :append

  alias_native :[]=, :attr
  alias_native :add_class, :addClass
  alias_native :append_to, :appendTo
  alias_native :has_class?, :hasClass
  alias_native :html=, :html
  alias_native :remove_attr, :removeAttr
  alias_native :remove_class, :removeClass
  alias_native :text=, :text
  alias_native :toggle_class, :toggleClass
  alias_native :value=, :val

  # Missing methods are assumed to be jquery plugins. These are called by
  # the given symbol name.
  def method_missing(symbol, *args, &block)
    %x{
      if (#{self}[#{symbol}]) {
        return #{self}[#{symbol}].apply(#{self}, args);
      }
    }

    super
  end

  def [](name)
    `#{self}.attr(name) || ""`
  end

  alias << append

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
      return (first && first.className) || "";
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

  def first
    `#{self}.length ? #{self}.first() : nil`
  end

  def html
    `#{self}.html() || ""`
  end

  def id
    %x{
      var first = #{self}[0];
      return (first && first.id) || "";
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

  def on(name, sel = nil, &block)
    `sel === nil ? #{self}.on(name, block) : #{self}.on(name, sel, block)`
    block
  end

  def off(name, sel, block = nil)
    `block === nil ? #{self}.off(name, sel) : #{self}.off(name, sel, block)`
  end

  alias size length

  alias succ next

  def value
    `#{self}.val() || ""`
  end
end
