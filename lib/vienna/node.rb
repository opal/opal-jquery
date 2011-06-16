require 'vienna/node/sizzle'

module Vienna
  class Node

    def initialize(type = :div)
      `self.$el = document.createElement(#{ type.to_s });`
      self
    end

    def to_s
      "<#{ tagname }>"
    end

    def [](name)
      name = name.to_s
      `return self.$el[name] || nil;`
    end

    def tagname
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

    def next_sibling
      `var elem = self.$el.nextSibling;

      while (elem) {
        if (elem.nodeType == 1) {
          return #{ Node.from_native `elem` };
        }
        elem = elem.nextSibling;
      }

      return nil;`
    end

    def previous_sibling
      `var elem = self.$el.previousSibling;

      while (elem) {
        if (elem.nodeType == 1) {
          return #{ Node.from_native `elem` };
        }
        elem = elem.previousSibling;
      }

      return nil;`
    end

    # @return [NodeSet]
    def children
      `var children = #{ NodeSet.new }, node = self.$el.firstChild;

      while (node) {
        if (node.nodeType === 1) {
          children.push(#{ Node.from_native `node` });
        }
        node = node.nextSibling;
      }
      return children;`
    end

    alias_method :next,       :next_sibling
    alias_method :previous,   :previous_sibling
    alias_method :prev,       :previous_sibling

    def inner_html
      `return self.$el.innerHTML;`
    end

    def inner_text
      `var elem = self.$el;

      return elem.textContent ? elem.textContent : elem.innerText;`
    end

    alias_method :html,   :inner_html
    alias_method :text,   :inner_text

    def self.from_native(elem)
      `var res = #{ allocate };
      res.$el = elem;
      return res;`
    end
  end
end

