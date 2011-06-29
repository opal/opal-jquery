require 'rquery/dom_events'

module Document
  extend Event::DomEvents

  def self.[](selector)
    return find_by_id selector if selector.is_a? Symbol
    `if (/^#([\w\-]*)$/.test(selector)) {
      var el;
      if (el = document.getElementById(selector.substr(1))) {
        return #{ Element.from_native `el` };
      }
      return nil;
    }
    var els = Sizzle(selector);
    var nodes = [];

    for (var i = 0, ii = els.length; i < ii; i++) {
      nodes.push(#{ Element.from_native `els[i]` });
    }

    return #{ Element::Set.new `nodes` };`
  end

  # @param {String} id
  def self.find_by_id(id)
    id = id.to_s
    `var el = document.getElementById(id);

    if (el) return #{ Element.from_native `el` };
    return nil;`
  end

  def self.title
    `return document.title;`
  end

  def self.title=(str)
    `return document.title = str;`
  end

  def self.body
    @body ||= Element.from_native `document.getElementsByTagName('body')[0]`
  end

  def self.head
    @head ||= Element.from_native `document.getElementsByTagName('head')[0]`
  end

  def self.scripts
    raise "Should return ElementSet of elements"
  end

  `self.$el = document;`

  @ready = false
  @ready_blocks = []

  # Takes a block and yields it once the host document is ready. If this is
  # called post document load then the block will be called instantly. If no
  # block is given then this method simply returns `true` or `false`
  # depending on whether the document has already loaded.
  #
  # @return [true, false]
  def self.ready?(&blk)
    if block_given?
      if @ready
        yield
      else
        @ready_blocks << blk
      end
    end
    @ready
  end

  def self.__handle_ready__
    return unless @ready
    blocks = @ready_blocks

    block.call while block = blocks.pop
  end

  `(function() {
    var ready_function;

    if (document.addEventListener) {
      document.addEventListener("DOMContentLoaded", ready_function, false);

      ready_function = function() {
        document.removeEventListener("DOMContentLoaded", ready_function, false);
        #{ @ready = true };
        #{ __handle_ready__ };
      };
    }
    else {
      window.attachEvent("onload", ready_function);
    }

    if (document.readyState == "complete") {
      setTimeout(ready_function, 0);
    }

  })();`
end

