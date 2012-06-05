class Element < `jQuery`

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

  def [](name)
    %x{
      var attr = this.attr(name);
      return attr == null ? nil : attr;
    }
  end

  def []=(name, value)
    `this.attr(name, value)`
  end

  def add_class(name)
    `this.addClass(name)`
  end

  def append_to_body
    `this.appendTo(document.body)`
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

  def on(name, &block)
    return unless block_given?

    %x{
      this.on(name, function() {
        return #{ block.call };
      });
    }
    block
  end

  def remove
    `this.remove()`
  end

  def remove_class(name)
    `this.removeClass(name)`
  end

  alias size length
end