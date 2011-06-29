require 'rquery/element/sizzle'
require 'rquery/element/attributes'

class Element
  include Event::DomEvents

  def initialize(type = :div)
    `self.$el = document.createElement(#{ type.to_s });`
    self
  end
  #
  # Removes all child nodes from the receiver element.
  #
  # @example HTML
  #
  #     <div id="some_element">
  #       <div></div>
  #       <span>Hello</span>
  #     </div>
  #
  # @example Ruby
  #
  #     Document[:some_element].clear
  #
  # @example Result HTML
  #
  #     <div id="some_element></div>
  #
  # @return [Element] returns the receiver
  def clear
    `var el = self.$el;
    while (el.firstChild) { el.removeChild(el.firstChild); }
    return self;`
  end

  # Returns true if the element does not have any child nodes or text
  # content, false otherwise. If an element is empty then it only
  # contains whitespace.
  #
  # @example HTML
  #
  #     <div id="a">
  #       <span></span>
  #     </div>
  #
  # @example Ruby
  #
  #     Document[:a].empty?           # => false
  #     Document[:a].clear.empty?     # => true
  #
  # @return [Boolean]
  def empty?
    `return /^\s*$/.test(self.$el.innerHTML) ? Qtrue : Qfalse;`
  end

  # Returns the element's next sibling, if one is present. If there
  # is not a next sibiling then nil is returned. RQuery ensures that
  # only an element can be returned and will skip any whitespace or
  # text nodes.
  #
  # @example HTML
  #
  #     <div id=foo">
  #       <p id="baz">Hello</p>
  #       <p id="bar">Goodbye</p>
  #       <p id="buzz">Bore da</p>
  #     </div>
  #
  # @example Try to get next sibling
  #
  #     Document[:baz].next     # => #<Element: div id="bar">
  #     Document[:bar].next     # => #<Element: div id="buzz">
  #
  # @example Try to get next sibling which doesn't exist
  #
  #     Document[:buzz].next    # => nil
  #
  # @return [Element, nil]
  def next
    `var elem = self.$el.nextSibling;

    while (elem) {
      if (elem.nodeType == 1) {
        return #{ Element.from_native `elem` };
      }
      elem = elem.nextSibling;
    }

    return nil;`
  end

  def prev
    `var elem = self.$el.previousSibling;

    while (elem) {
      if (elem.nodeType == 1) {
        return #{ Node.from_native `elem` };
      }
      elem = elem.previousSibling;
    }

    return nil;`
  end

  def tag
    `var tag = self.$el.tagName;
    return tag ? tag.toLowerCase() : "";`
  end

  def parent
    `var el = self.$el.parentNode;

    if (el) {
      return #{ self.class.from_native `el` };
    }

    return nil;`
  end

  # @return [NodeSet]
  def children
    `var children = #{ ElementSet.new }, node = self.$el.firstChild;

    while (node) {
      if (node.nodeType === 1) {
        children.push(#{ Element.from_native `node` });
      }
      node = node.nextSibling;
    }
    return children;`
  end

  def to_s
    t = tag
    attrs = []

    if t == 'script'
      attrs << "src=#{src.inspect}" if src
      "#<Element: script #{ attrs.join ' ' }>"
    else
      attrs << "id=#{id.inspect}" if id
      "#<Element: #{t} #{attrs.join ' ' }>"
    end
  end

  def self.from_native(elem)
    `var res = #{ allocate };
    res.$el = elem;
    return res;`
  end
end

