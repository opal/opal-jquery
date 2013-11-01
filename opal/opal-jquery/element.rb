class Element
  include Enumerable

  class << self
    def find(selector)
      self.new `$(#{selector})`
    end

    alias [] find
    alias parse find

    def id(id)
      %x{
        var el = document.getElementById(id);

        if (!el) {
          return nil;
        }

        return #{new `el`};
      }
    end

    def define_manipulation(name)
      define_method(name) do |content|
        %x{
          if (!content._isString) {
            content = content['native'];
          }

          #@native[name](content);
        }

        self
      end
    end

    def define_traversing(name)
      define_method(name) do
        Element.new `#@native[name]()`
      end
    end

    def expose(*methods)
      methods.each do |meth|
        define_method(meth) do
          `#@native[meth].apply(#@native, arguments)`
        end
      end
    end
  end

  define_manipulation :after
  define_manipulation :before
  define_manipulation :append
  define_manipulation :prepend

  define_traversing :next
  define_traversing :prev
  define_traversing :parent
  define_traversing :parents
  define_traversing :children

  def initialize(str)
    if String === str
      @native = `$(document.createElement(#{str}))`
    else
      @native = `$(#{str})`
    end
  end

  def method_missing(sym, *args)
    `#@native[sym].apply(#@native, args)`
  end

  def remove
    `#@native.remove()`
    self
  end

  def hide
    `#@native.hide()`
  end

  def show
    `#@native.show()`
  end

  def toggle
    `#@native.toggle()`
  end

  def siblings(sel=nil)
    if sel
      Element.new `#@native.siblings(sel)`
    else
      Element.new `#@native.siblings()`
    end
  end

  def append_to(target)
    %x{
      if (!target._isString) {
        target = target['native'];
      }

      #@native.appendTo(target);
    }

    self
  end

  def selector
    `#@native.selector`
  end

  # We alias some jquery methods to common ruby method names.
  alias succ next
  alias << append

  def focus
    `#@native.focus()`
    self
  end

  def height
    `#@native.height()`
  end

  def width
    `#@native.width()`
  end

  def serialize
    `#@native.serialize()`
  end

  def is(selector)
    `#@native.is(selector)`
  end

  def data(key, val=undefined)
    %x{
      if (val == undefined) {
        return #@native.data(key);
      }
      else {
        return #@native.data(key, val);
      }
    }
  end

  def closest(selector)
    Element.new `#@native.closest(selector)`
  end

  def find(content)
    Element.new `#@native.find(content)`
  end

  def add_class(name)
    `#@native.addClass(name)`
    self
  end

  def remove_class(name)
    `#@native.removeClass(name)`
    self
  end

  def has_class?(name)
    `#@native.hasClass(name)`
  end

  def toggle_class(name)
    `#@native.toggleClass(name)`
    self
  end

  def to_n
    @native
  end

  def [](name)
    `#@native.attr(name) || ""`
  end

  def []=(name, value)
    `#@native.attr(name, value)`
  end

  def attr(name, val=nil)
    if val
      self[name] = val
    else
      self[name]
    end
  end

  def add_attribute(name)
    `#@native.attr(name, '')`
  end

  def remove_attr(name)
    `#@native.removeAttr(name)`
    self
  end

  def has_attribute?(name)
    `!!#@native.attr(name)`
  end

  def append_to_body
    `#@native.appendTo(document.body)`
  end

  def append_to_head
    `#@native.appendTo(document.head)`
  end

  # Returns the element at the given index as a new `Element` instance.
  # Negative indexes can be used and are counted from the end. If the
  # given index is outside the range then `nil` is returned.
  def at(index)
    %x{
      var length = #@native.length;

      if (index < 0) {
        index += length;
      }

      if (index < 0 || index >= length) {
        return nil;
      }

      return #{Element.new `$(#@native[index])`};
    }
  end

  # Returns the CSS class name of the firt element in #{self} collection.
  # If the collection is empty then an empty string is returned. Only
  # the class name of the first element will ever be returned.
  def class_name
    %x{
      var first = #@native[0];
      return (first && first.className) || "";
    }
  end

  # Sets the CSS class name of every element in #{self} collection to the
  # given string. #{self} does not append the class names, it replaces
  # the entire current class name.
  def class_name=(name)
    %x{
      for (var i = 0, length = #@native.length; i < length; i++) {
        #@native[i].className = name;
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
  def css(name, value=nil)
    if value.nil? && name.is_a?(String)
      return `#@native.css(name)`
    else
      name.is_a?(Hash) ? `#@native.css(#{name.to_n})` : `#@native.css(name, value)`
    end
    self
  end

  # Set css values over time to create animations. The first parameter is a
  # set of css properties and values to animate to. The first parameter
  # also accepts a special :speed value to set animation speed. If a block
  # is given, the block is run as a callback when the animation finishes.
  def animate(params, &block)
    speed = params.delete(:speed) || 400
    %x{
      #@native.animate(#{params.to_n}, #{speed}, function() {
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
    `#@native[#{name}].apply(#@native, #{args})`
  end

  def visible?
    `#@native.is(':visible')`
  end

  def offset
    Hash.from_native(`#@native.offset()`)
  end

  def each
    `for (var i = 0, length = #@native.length; i < length; i++) {`
      yield Element.new `$(#@native[i])`
    `}`
    self
  end

  def filter(selector)
    Element.new `#@native.filter(selector)`
  end

  def first
    `#@native.length ? #{Element.new `#@native.first()`} : nil`
  end

  def last
    Element.new `#@native.last()` unless size == 0
  end

  def stop(*args)
    `#@native.stop.apply(#@native, args)`
    self
  end

  def wrap(content)
    %x{
      if (!content._isString) {
        content = content['native'];
      }

      return #{Element.new `#@native.wrap(content)`};
    }
  end

  def text
    `#@native.text() || ""`
  end

  def text=(text)
    `#@native.text(text)`
    self
  end

  def html
    `#@native.html() || ""`
  end

  def html=(content)
    %x{
      if (!content._isString) {
        content = content['native'];
      }

      #@native.html(content);
    }

    self
  end

  def id
    %x{
      var first = #@native[0];
      return (first && first.id) || "";
    }
  end

  def id=(id)
    %x{
      var first = #@native[0];

      if (first) {
        first.id = id;
      }

      return #{self};
    }
  end

  def tag_name
    `#@native.length > 0 ? #@native[0].tagName.toLowerCase() : #{nil}`
  end

  def inspect
    %x{
      var val, el, str, result = [];

      for (var i = 0, length = #@native.length; i < length; i++) {
        el  = #@native[i];
        str = "<" + el.tagName.toLowerCase();

        if (val = el.id) str += (' id="' + val + '"');
        if (val = el.className) str += (' class="' + val + '"');

        result.push(str + '>');
      }

      return '#<Element [' + result.join(', ') + ']>';
    }
  end

  def length
    `#@native.length`
  end

  def any?
    `#@native.length > 0`
  end

  def empty?
    `#@native.length === 0`
  end

  alias empty? none?

  def clone
    Element.new `#@native.clone()`
  end

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
        #@native.on(name, wrapper);
      }
      else {
        #@native.on(name, sel, wrapper);
      }
    }

    block
  end

  def off(name, sel, block = nil)
    %x{
      if (sel == null) {
        return #@native.off(name);
      }
      else if (block === nil) {
        return #@native.off(name, sel._jq_wrap);
      }
      else {
        return #@native.off(name, sel, block._jq_wrap);
      }
    }
  end

  def trigger(*args)
    `#@native.trigger.apply(#@native, args)`
  end

  alias size length

  def val
    `#@native.val() || ""`
  end
  alias value val

  def val=(name, val)
    `#@native.val(name, val)`
    val
  end
  alias value= val=

  def scroll_left=(left)
    `#@native.scrollLeft(left)`
    left
  end

  def scroll_top=(top)
    `#@native.scrollTop(top)`
  end

  def scroll_left
    `#@native.scrollLeft()`
  end

  def scroll_top
    `#@native.scrollTop()`
  end

  def slide_down(*args)
    `#@native.slideDown.apply(#@native, args)`
  end

  def slide_up(*args)
    `#@native.slideUp.apply(#@native, args)`
  end

  def slide_toggle(*args)
    `#@native.slideToggle.apply(#@native, args)`
  end

  def fade_toggle(*args)
    `#@native.fadeToggle.apply(#@native, args)`
  end
end
