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

class DOM < `fn`
  def self.find(selector)
    `$(selector)`
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

  def [](name)
    `this.attr(name) || ""`
  end

  def []=(name, value)
    `this.attr(name, value)`
  end

  # Add the given content to inside each element in the receiver. The
  # content may be a HTML string or a `DOM` instance. The inserted
  # content is added to the end of the receiver.
  #
  # @example Given HTML String
  #
  #     DOM.find('ul').append '<li>list content</li>'
  #
  # @example Given an existing DOM node
  #
  #     DOM.id('checkout') << Dom.id('total-price-label')
  #
  # @param [String, DOM] content HTML string or DOM content
  # @return [DOM] returns receiver
  def <<(str)
    `this.append(str)`
  end

  def add_class(name)
    `this.addClass(name)`
  end

  # Add the given content after each element in the receiver. The given
  # content may be a HTML string, or a `DOM` instance.
  #
  # @example Given HTML String
  #
  #     DOM.find('.label').after '<p>Content after label</>'
  #
  # @example Given existing DOM nodes
  #
  #     DOM.find('.price').after DOM.id('checkout-link')
  #
  # @param [String, DOM] content HTML string or dom content
  # @return [DOM] returns self
  def after(content)
    `this.after(content)`
  end

  alias append <<

  # Appends the elements in this object into the target element. This
  # method is the reverse of using `#append` on the target with this
  # instance as the argument.
  #
  # @example
  #
  #     DOM.parse('<p>Hello</p>').append_to DOM.id('foo')
  #
  # @param [DOM] target the target to insert into
  # @return [DOM] returns the receiver
  def append_to(target)
    `this.appendTo(target)`
  end

  def append_to_body
    `this.appendTo(document.body)`
  end

  def append_to_head
    `this.appendTo(document.head)`
  end

  def at(index)
    %x{
      var length = this.length;

      if (index < 0) {
        index += length;
      }

      if (index < 0 || index >= length) {
        return nil;
      }

      return $(this[index]);
    }
  end

  def children
    `this.children()`
  end

  def class_name
    %x{
      var first = this[0];

      if (!first) {
        return "";
      }

      return first.className || "";
    }
  end

  def class_name=(name)
    %x{
      for (var i = 0, length = this.length; i < length; i++) {
        this[i].className = name;
      }
    }
    name
  end

  def css(name, value)
    %x{
      if (value == null) {
        return this.css(name);
      }
      else {
        return this.css(name, value);
      }
    }
  end

  def each
    `for (var i = 0, length = this.length; i < length; i++) {`
      yield `$(this[i])`
    `}`
    self
  end

  def first
    `this.length ? this.first() : nil`
  end

  def has_class?(name)
    `this.hasClass(name)`
  end

  def html
    `this.html() || ""`
  end

  def html=(content)
    `this.html(content)`
  end

  def id
    %x{
      var first = this[0];

      if (!first) {
        return "";
      }

      return first.id || "";
    }
  end

  def id=(id)
    %x{
      var first = this[0];

      if (first) {
        first.id = id;
      }

      return this;
    }
  end

  def inspect
    %x{
      var val, el, str, result = [];

      for (var i = 0, length = this.length; i < length; i++) {
        el  = this[i];
        str = "<" + el.tagName.toLowerCase();

        if (val = el.id) str += (' id="' + val + '"');
        if (val = el.className) str += (' class="' + val + '"');

        result.push(str + '>');
      }

      return '[' + result.join(', ') + ']';
    }
  end

  def length
    `this.length`
  end

  def next
    `this.next()`
  end

  def on(name, &block)
    return unless block_given?

    %x{
      this.on(name, function() {
        return #{ block.call };
      });
    }
    block
  end

  def parent
    `this.parent()`
  end

  def remove
    `this.remove()`
  end

  def remove_class(name)
    `this.removeClass(name)`
  end

  alias size length

  alias succ next

  def value
    `this.val() || ""`
  end

  def value=(val)
    `this.val(val)`
  end
end