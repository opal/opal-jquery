# Instances of Element are just jquery instances, and wrap 1 or more
# native dom elements.

%x{
  var root = __opal.global, dom_class;

  if (root.jQuery) { dom_class = jQuery }
  else if (root.Zepto) { dom_class = Zepto.zepto.Z; }
}

Class.bridge_class 'Element', `dom_class`

class Element
  include Enumerable

  def self.find(selector)
    `$(#{selector})`
  end

  def self.[](selector)
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

  attr_reader :selector

  # Bridged functions - we just expose all core jquery functions as ruby
  # methods on this class.
  expose :after, :before, :parent, :parents, :prepend, :prev, :remove
  expose :hide, :show, :toggle, :children, :blur, :closest, :data
  expose :focus, :find, :next, :siblings, :text, :trigger, :append
  expose :height, :width, :serialize, :is, :filter, :last, :first
  expose :wrap, :stop, :clone

  # We alias some jquery methods to common ruby method names.
  alias succ next
  alias << append

  # Here we map the remaining jquery methods, but change their names to
  # snake_case to be more consistent with ruby.
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
  alias_native :scroll_left=, :scrollLeft
  alias_native :scroll_left, :scrollLeft
  alias_native :remove_attribute, :removeAttr
  alias_native :slide_down, :slideDown
  alias_native :slide_up, :slideUp
  alias_native :slide_toggle, :slideToggle
  alias_native :fade_toggle, :fadeToggle

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

  def add_attribute name
    self[name] = ''
  end

  def has_attribute? name
    `!!#{self}.attr(name)`
  end

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
      return `#{self}.css(name)`
    else
      name.is_a?(Hash) ? `#{self}.css(#{name.to_n})` : `#{self}.css(name, value)`
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
      #{self}.animate(#{params.to_n}, #{speed}, function() {
        #{block.call if block_given?}
      })
    }
  end

  # Start a visual effect (e.g. fadeIn, fadeOut, …) passing its name.
  # Underscored style is automatically converted (e.g. `effect(:fade_in)`).
  # Also accepts additional arguments and a block for the finished callback.
  def effect(name, *args, &block)
    name = name.gsub(/_\w/) { |match| match[1].upcase }
    args = args.map { |a| a.to_n if a.respond_to? :to_n }.compact
    args << `function() { #{block.call if block_given?} }`
    `#{self}[#{name}].apply(#{self}, #{args})`
  end

  def visible?
    `#{self}.is(':visible')`
  end

  def offset
    Hash.from_native(`#{self}.offset()`)
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

  def tag_name
    `#{self}.length > 0 ? #{self}[0].tagName.toLowerCase() : #{nil}`
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

      return '#<Element [' + result.join(', ') + ']>';
    }
  end

  def length
    `#{self}.length`
  end

  def any?
    `#{self}.length > 0`
  end

  def empty?
    `#{self}.length === 0`
  end

  alias empty? none?

  def on(name, sel = nil, &block)
    `sel == nil ? #{self}.on(name, block) : #{self}.on(name, sel, block)`
    block
  end

  def off(name, sel, block = nil)
    `block == nil ? #{self}.off(name, sel) : #{self}.off(name, sel, block)`
  end

  alias size length

  def value
    `#{self}.val() || ""`
  end
end
