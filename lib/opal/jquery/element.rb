require 'native'
require 'opal/jquery/constants'

# {Element} is a toll-free bridged class that maps to native jQuery instances.
#
# As {Element} maps to a jQuery object, it can be used to represent 0, 1, or
# more actual DOM elements. {Element} exposes a more ruby-esqe interface to
# jQuery.
#
# ## Usage
#
# {Element} instances can be created in a number of ways.
#
# ### Creating new Elements
#
# A new element can be created using the {Element.new} method.
#
#     el = Element.new(:div)
#     el.id = "title"
#     p el
#     # => #<Element [<div id="title">]>
#
# This is a nicer version of creating a javascript element using
# `document.createElement` and then wrapping it in a jquery object.
#
# ### Finding existing elements in dom
#
# Any valid jQuery selector expressions can be used with either {Element.find}
# or {Element.[]}.
#
#     foos = Element.find('.foo')
#     # => #<Element [<div class="foo">]>
#
#     links = Element['a']
#     # => #<Element [<a>, <a class="bar">]>
#
# Alternatively, {Element.id} can be used to find an element by its document
# id (or nil is returned for no match).
#
#     bar = Element.id 'bar'
#     # => Element or nil
#
# ### DOM Content from string
#
# Finally, an {Element} instance can be created by parsing a string of html
# content. This will parse multiple elements, like jquery, if string content
# contains them:
#
#     Element.parse '<div id="title">hello world</div>'
#     # => #<Element [<div id="title">]>
#
class Element < `#{JQUERY_CLASS.to_n}`
  `var $ = #{JQUERY_SELECTOR.to_n}` # cache $ for SPEED

  include Enumerable

  # Find elements by the given css selector.
  #
  # Returns an empty {Element} if no matching elements.
  #
  # @param selector [String] css selector
  # @return [Element]
  def self.find(selector)
    `$(#{selector})`
  end

  # Find elements by the given css selector.
  #
  # Returns an empty {Element} if no matching elements.
  #
  # @param selector [String] css selector
  # @return [Element]
  def self.[](selector)
    `$(#{selector})`
  end

  # Find an element by the given id.
  #
  # If no matching element, then `nil` will be returned. A matching element
  # becomes the sole element in the returned collection.
  #
  # @param id [String] dom element id
  # @return [Element, nil]
  def self.id(id)
    %x{
      var el = document.getElementById(id);

      if (!el) {
        return nil;
      }

      return $(el);
    }
  end

  # Create a new dom element, wrapped as {Element} instance with the given
  # `tag` name.
  #
  # @param tag [String] valid html tag name
  # @return [Element]
  def self.new(tag = 'div')
    `$(document.createElement(tag))`
  end

  # Parse a string of html content into an {Element} instance.
  #
  # If no valid elements in string, then an empty collection will be returned.
  #
  # @param str [String] html content to parse
  # @return [Element]
  def self.parse(str)
    `$.parseHTML ? $($.parseHTML(str)) : $(str)`
  end

  # Expose jQuery plugins to become available in ruby code. By default,
  # jQuery methods or plugins must be manually exposed as ruby methods.
  # This method simply creates an aliasing ruby method to call the original
  # javascript function.
  #
  # @example
  #   # Expose bootstraps jQuery `modal` function
  #   Element.expose :modal
  #
  #   Element.find('.my-modal').modal
  #
  # @param methods [String, Symbol] all methods to expose to ruby
  # @return nil
  def self.expose(*methods)
    methods.each do |method|
      alias_native method
    end
  end

  # Access the jQuery-wrapped `window` object, equivalent to
  # `Element.find(`window`)`.
  #
  # @example
  #   Element.window.on(:resize) { |event| … }
  # @return [Element]
  def self.window
    @window ||= find(`window`)
  end

  # @return The original css selector used to create {Element}
  attr_reader :selector

  # @!method after(content)
  #
  # Inserts the given `content` after each element in this set of elements.
  # This method can accept either another {Element}, or a string.
  #
  # @param content [String, Element] string or element to insert
  alias_native :after

  # @!method before(content)
  #
  # Insert the given `content` before each element in this set of elements.
  # The given `content` can be either an {Element}, or a string.
  #
  # @param content [String, Element] string or element to insert
  alias_native :before

  # @!method parent(selector = nil)
  #
  # Returns a new {Element} set with the parents of each element in this
  # collection. An optional `selector` argument can be used to filter the
  # results to match the given selector. Result may be empty.
  #
  # @param selector [String] optional filter
  # @return [Element]
  alias_native :parent

  # @!method parents(selector = nil)
  #
  # Returns a new {Element} set with all parents of each element in this
  # collection. An optional `selector` may be provided to filter the
  # selection. Resulting collection may be empty.
  #
  # @example Without filtering collection
  #   Element.find('#foo').parents
  #   # => #<Element [<div id="wrapper">, <body>, <html>]>
  #
  # @example Using a filter
  #   Element.find('#foo').parents('div')
  #   # => #<Element [<div id="wrapper">]
  #
  # @param selector [String] optional filter
  # @return [Element]
  alias_native :parents

  # @!method prev(selector = nil)
  alias_native :prev

  # @!method remove(selector = nil)
  alias_native :remove

  # @!method hide(duration = 400)
  alias_native :hide

  # @!method show(duration = 400)
  alias_native :show

  # @!method toggle(duration = 400)
  alias_native :toggle

  # @!method children(selector = nil)
  alias_native :children

  # @!method blur
  alias_native :blur

  # @!method closest(selector)
  alias_native :closest

  # @!method detach(selector = nil)
  alias_native :detach

  # @!method focus
  alias_native :focus

  # @!method find(selector)
  alias_native :find

  # @!method next(selector = nil)
  alias_native :next

  # @!method siblings(selector = nil)
  alias_native :siblings

  # @!method text(text = nil)
  #
  # Get or set the text content of each element in this collection. Setting
  # the content is provided as a compatibility method for jquery. Instead
  # {#text=} should be used for setting text content.
  #
  # If no `text` content is provided, then the text content of this element
  # will be returned.
  #
  # @see #text=
  # @param text [String] text content to set
  # @return [String]
  alias_native :text

  # @!method trigger(event)
  #
  # Trigger an event on this element. The given `event` specifies the event
  # type.
  #
  # @param event [String, Symbol] event type
  alias_native :trigger

  # @!method append(content)
  #
  # @param content [String, Element]
  alias_native :append

  # @!method prepend(content)
  #
  # @param content [String, Element]
  alias_native :prepend

  # @!method serialize
  alias_native :serialize

  # @!method is(selector)
  # @return [true, false]
  alias_native :is

  # @!method filter(selector)
  # @param selector [String]
  # @return [Element]
  alias_native :filter

  # @!method not(selector)
  # @param selector [String]
  # @return [Element]
  alias_native :not

  # @!method last
  #
  # Returns a new {Element} instance containing the last element in this
  # current set.
  #
  # @return [Element]
  alias_native :last

  # @!method wrap(wrapper)
  # @param wrapper [String, Element] html content, selector or element
  # @return [Element]
  alias_native :wrap

  # @!method stop
  #
  # Stop any currently running animations on element.
  alias_native :stop

  # @!method clone
  #
  # Clone all elements inside this collection, and return as a new instance.
  # @return [Element]
  alias_native :clone

  # @!method empty
  #
  # Remove all child nodes from each element in this collection.
  alias_native :empty

  # @!method get
  alias_native :get

  # @!method prop(name, value = nil)
  #
  # Get or set the property `name` on each element in collection.
  alias_native :prop

  alias succ next
  alias << append

  # @!method add_class(class_name)
  alias_native :add_class, :addClass

  # @!method append_to(element)
  alias_native :append_to, :appendTo

  # @!method has_class?(class_name)
  alias_native :has_class?, :hasClass

  # @!method html=(content)
  #
  # Set the html content of each element in this collection to the passed
  # content. Content can either be a string or another {Element}.
  #
  # @param content [String, Element]
  alias_native :html=, :html

  # @!method index(selector_or_element = nil)
  alias_native :index

  # @!method is?(selector)
  alias_native :is?, :is

  # @!method remove_attr(attr)
  alias_native :remove_attr, :removeAttr

  # @!method remove_class(class_name)
  alias_native :remove_class, :removeClass

  # @!method submit()
  alias_native :submit

  # @!method text=(text)
  #
  # Set text content of each element in this collection.
  #
  # @see #text
  # @param text [String]
  alias_native :text=, :text

  # @!method toggle_class
  alias_native :toggle_class, :toggleClass

  # @!method value=(value)
  alias_native :value=, :val

  # @!method scroll_top=(value)
  alias_native :scroll_top=, :scrollTop

  # @!method scroll_top
  alias_native :scroll_top, :scrollTop

  # @!method scroll_left=(value)
  alias_native :scroll_left=, :scrollLeft

  # @!method scroll_left
  alias_native :scroll_left, :scrollLeft

  # @!method remove_attribute(attr)
  alias_native :remove_attribute, :removeAttr

  # @!method slide_down(duration = 400)
  alias_native :slide_down, :slideDown

  # @!method slide_up(duration = 400)
  alias_native :slide_up, :slideUp

  # @!method slide_toggle(duration = 400)
  alias_native :slide_toggle, :slideToggle

  # @!method fade_toggle(duration = 400)
  alias_native :fade_toggle, :fadeToggle

  # @!method height=(value)
  alias_native :height=, :height

  # @!method width=(value)
  alias_native :width=, :width

  # @!method outer_width(include_margin = false)
  alias_native :outer_width, :outerWidth

  # @!method outer_height(include_margin = false)
  alias_native :outer_height, :outerHeight

  def to_n
    self
  end

  def [](name)
    %x{
      var value = self.attr(name);
      if(value === undefined) return nil;
      return value;
    }
  end

  # Set the given attribute `attr` on each element in this collection.
  #
  # @see http://api.jquery.com/attr/
  def []=(name, value)
    `return self.removeAttr(name)` if value.nil?
    `self.attr(name, value)`
  end

  def attr(*args)
    %x{
      var size = args.length;
      switch (size) {
      case 1:
        return #{self[`args[0]`]};
        break;
      case 2:
        return #{self[`args[0]`] = `args[1]`};
        break;
      default:
        #{raise ArgumentError, '#attr only accepts 1 or 2 arguments'}
      }
    }
  end

  def has_attribute?(name)
    `self.attr(name) !== undefined`
  end

  def append_to_body
    `self.appendTo(document.body)`
  end

  def append_to_head
    `self.appendTo(document.head)`
  end

  # Returns the element at the given index as a new {Element} instance.
  # Negative indexes can be used and are counted from the end. If the
  # given index is outside the range then `nil` is returned.
  #
  # @param index [Integer] index
  # @return [Element, nil]
  def at(index)
    %x{
      var length = self.length;

      if (index < 0) {
        index += length;
      }

      if (index < 0 || index >= length) {
        return nil;
      }

      return $(self[index]);
    }
  end

  # Returns the CSS class name of the firt element in self collection.
  # If the collection is empty then an empty string is returned. Only
  # the class name of the first element will ever be returned.
  #
  # @return [String]
  def class_name
    %x{
      var first = self[0];
      return (first && first.className) || "";
    }
  end

  # Sets the CSS class name of every element in self collection to the
  # given string. self does not append the class names, it replaces
  # the entire current class name.
  #
  # @param name [String] class name to set
  def class_name=(name)
    %x{
      for (var i = 0, length = self.length; i < length; i++) {
        self[i].className = name;
      }
    }
    self
  end

  # Get or set css properties on each element in self collection. If
  # only the `name` is given, then that css property name is read from
  # the first element in the collection and returned. If the `value`
  # property is also given then the given css property is set to the
  # given value for each of the elements in self collection. The
  # property can also be a hash of properties and values.
  def css(name, value=nil)
    if value.nil? && name.is_a?(String)
      return `self.css(name)`
    else
      name.is_a?(Hash) ? `self.css(#{name.to_n})` : `self.css(name, value)`
    end
    self
  end

  # Set css values over time to create animations. The first parameter is a
  # set of css properties and values to animate to. The first parameter
  # also accepts a special :speed value to set animation speed. If a block
  # is given, the block is run as a callback when the animation finishes.
  def animate(params, &block)
    speed = params.has_key?(:speed) ? params.delete(:speed) : 400
    %x{
      self.animate(#{params.to_n}, #{speed}, function() {
        #{block.call if block_given?}
      })
    }
  end

  def data(*args)
    %x{
      var result = self.data.apply(self, args);
      return result == null ? nil : result;
    }
  end

  # Start a visual effect (e.g. fadeIn, fadeOut, …) passing its name.
  # Underscored style is automatically converted (e.g. `effect(:fade_in)`).
  # Also accepts additional arguments and a block for the finished callback.
  def effect(name, *args, &block)
    name = name.gsub(/_\w/) { |match| match[1].upcase }
    args = args.map { |a| a.to_n if a.respond_to? :to_n }.compact
    args << `function() { #{block.call if block_given?} }`
    `self[#{name}].apply(self, #{args})`
  end

  def visible?
    `self.is(':visible')`
  end

  def offset
    Native(`self.offset()`)
  end

  def each
    `for (var i = 0, length = self.length; i < length; i++) {`
      yield `$(self[i])`
    `}`
    self
  end

  def first
    `self.length ? self.first() : nil`
  end

  def html(content = undefined)
    %x{
      if (content != null) {
        return self.html(content);
      }

      return self.html() || '';
    }
  end

  def id
    %x{
      var first = self[0];
      return (first && first.id) || "";
    }
  end

  def id=(id)
    %x{
      var first = self[0];

      if (first) {
        first.id = id;
      }

      return self;
    }
  end

  def tag_name
    `self.length > 0 ? self[0].tagName.toLowerCase() : #{nil}`
  end

  def inspect
    %x{
      if      (self[0] === document) return '#<Element [document]>'
      else if (self[0] === window  ) return '#<Element [window]>'

      var val, el, str, result = [];

      for (var i = 0, length = self.length; i < length; i++) {
        el  = self[i];
        if (!el.tagName) { return '#<Element ['+el.toString()+']'; }

        str = "<" + el.tagName.toLowerCase();

        if (val = el.id) str += (' id="' + val + '"');
        if (val = el.className) str += (' class="' + val + '"');

        result.push(str + '>');
      }

      return '#<Element [' + result.join(', ') + ']>';
    }
  end

  def to_s
    %x{
      var val, el, result = [];

      for (var i = 0, length = self.length; i < length; i++) {
        el  = self[i];

        result.push(el.outerHTML)
      }

      return result.join(', ');
    }
  end

  # Returns the number of elements in this collection. May be zero.
  # @return [Integer]
  def length
    `self.length`
  end

  # Returns `true` if this collection has 1 or more elements, `false`
  # otherwise.
  #
  # @return [true, false]
  def any?
    `self.length > 0`
  end

  # Returns `true` if this collection contains no elements, `false` otherwise.
  #
  # @return [true, false]
  def empty?
    `self.length === 0`
  end

  alias empty? none?

  def on(name, sel = nil, &block)
    %x{
      var wrapper = function(evt) {
        if (evt.preventDefault) {
          evt = #{Event.new `evt`};
        }

        return block.apply(null, arguments);
      };

      block._jq_wrap = wrapper;

      if (sel == nil) {
        self.on(name, wrapper);
      }
      else {
        self.on(name, sel, wrapper);
      }
    }

    block
  end

  def one(name, sel = nil, &block)
    %x{
      var wrapper = function(evt) {
        if (evt.preventDefault) {
          evt = #{Event.new `evt`};
        }

        return block.apply(null, arguments);
      };

      block._jq_wrap = wrapper;

      if (sel == nil) {
        self.one(name, wrapper);
      }
      else {
        self.one(name, sel, wrapper);
      }
    }

    block
  end

  def off(name, sel, block = nil)
    %x{
      if (sel == null) {
        return self.off(name);
      }
      else if (block === nil) {
        return self.off(name, sel._jq_wrap);
      }
      else {
        return self.off(name, sel, block._jq_wrap);
      }
    }
  end

  # Serializes a form into an Array of Hash objects.
  #
  # @return [Array<Hashes>]
  def serialize_array
    `self.serializeArray()`.map { |e| Hash.new(e) }
  end

  alias size length

  def value
    `self.val() || ""`
  end

  def height
    `self.height() || nil`
  end

  def width
    `self.width() || nil`
  end

  def position
    Native(`self.position()`)
  end
end
