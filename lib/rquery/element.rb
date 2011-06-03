require 'rquery/sizzle'
require 'rquery/css'
require 'rquery/dom_events'

class RQuery < Array

  # include Enumerable
  # include DOMEvents

  class << self

    def from_native(*elems)
      `var len = elems.length;

      var res = #{ allocate };

      if (len == 0) {
        // do nothing when empty?
      }
      else if (len == 1) {
        res[0] = res;
        res.$elem = elems[0];
      }
      else {
        res.$elem = elems[0];
        for (var i = 0; i < len; i++) {
          res[i] = #{ from_native `elems[i]` };
        }
      }

      return res;`
    end

    # Find an element by its given id
    def find_by_id(id)
      `var elem = document.getElementById(#{ id.to_s });

      if (!elem) {
        return nil;
      }

      return #{ from_native `elem` };`
    end

    # Direct mapping on top of Sizzle()
    def find(selector)
      if selector.is_a? Symbol
        find_by_id selector.to_s
      else
        from_native *`Sizzle(selector)`
      end
    end

    alias_method :[], :find
  end

  # Access the previous rquery context
  attr_accessor :prev_context

  def initialize(type = 'div')
    `self.length = 1;
    self[0] = self;
    self.$elem = document.createElement(type);`
    self
  end

  def find(selector)
    `var res = #{ self.class.allocate }, elem, ary = [], found, len;

    for (var i = 0, ii = self.length; i < ii; i++) {
      len = ary.length;
      elem = self[i].$elem;
      Sizzle(selector, elem, ary);

      for (var j = len; j < ary.length; j++) {
        for (var k = 0; k < len; k++) {
          if (ary[j] == ary[k]) {
            ary.splice(j--, 1);
            break;
          }
        }
      }
    }

    return #{ self.class.from_native *`ary` };`
  end

  # Returns this objects previous context, if it exists. If it does not have
  # a previous context then the document instance of RQuery will be returned.
  #
  # This provides a useful means of chaining sub query calls where the
  # contexts can be almost pushed and popped with {#find} and {#end}
  # respectively.
  #
  # The 'document' instance of rquery represents the top level selector
  # scope. When any {RQuery.find} is done, the document is the basis for
  # searching the elements.
  #
  # @return {RQuery}
  def end
    @prev_context || self.class.document
  end

  # Returns a string representation of the collection of elements. If the
  # receiver contains a single element, then it will display the tag name,
  # id and class of the receiver. If more than one element is present, then
  # the inspection string will just contain the number of contained elements.
  #
  # @return [String]
  def to_s
    if length == 1
      "#<RQuery: div id=\"#{id}\">"
    else
      "[#{join ', '}]"
    end
    # ""
  end

  def id
    `return self.$elem.id || nil;`
  end

  def next
    `var len = self.length, elem;

    if (len == 1) {
      elem = self.$elem.nextSibling;

      while (elem) {
        if (elem.nodeType == 1) {
          return #{ self.class.from_native `elem` };
        }
        elem = elem.nextSibling;
      }

      return #{ nil };
    } else {
      var res = [], i;

      for (i = 0; i < len; i++) {
        elem = self[i].$elem.nextSibling;

        while (elem) {
          if (elem.nodeType == 1) {
            res.push(elem);
          }
          elem = elem.nextSibling;
        }
      }
    }

    return #{ self.class.from_native *`res` };`
  end
end

