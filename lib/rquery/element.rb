require 'rquery/element/sizzle'
require 'rquery/element/attributes'

module RQuery
  class Element

    def initialize(type = :div)
      `self.$el = document.createElement(#{ type.to_s });`
      self
    end

    def to_s
      str = "<#{tag}"
      str += " src=#{src.inspect}" if src
      str += ">"
      str
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

    alias_method :next,       :next_sibling

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

    alias_method :previous,   :previous_sibling
    alias_method :prev,       :previous_sibling

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

    def self.from_native(elem)
      `var res = #{ allocate };
      res.$el = elem;
      return res;`
    end
  end
end

