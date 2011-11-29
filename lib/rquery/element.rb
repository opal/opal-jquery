require 'rquery/sizzle'
require 'rquery/boot_element'

class Element
  ##
  # Helper function to give the native element the class and method
  # table properties so that it can act like a regular ruby object.
  #
  # This is inlined purely for performance: converting lots of
  # elements will add overhead we wish to avoid.
  `
    function wrap_element(elm) {
      elm.$k = self;
      elm.$m = self.$m_tbl;
      return elm;
    };
  `

  ##
  # Main query method. If given a string selector that looks like an id,
  # then a single element, or nil, will be returned.
  #
  # If a generic selector is given then an array of elements will be
  # returned.
  #
  # Usage:
  #
  #     Element.query '#foo'      # => #<Element foo>
  #     Element.query 'p'         # => [#<Element>, ...]
  def self.query sel
    `
      if (sel && typeof(sel) === 'string' && sel.charAt(0) === '#') {
        var elm = document.getElementById(sel.substr(1));

        if (elm) {
          return wrap_element(elm);
        }
      }

      var arr = Sizzle(sel);

      for (var i = 0, ii = arr.length; i < ii; i++) {
        arr[i] = wrap_element(arr[i]);
      }

      return arr;
    `
  end

  def self.body
    `wrap_element(document.body)`
  end

  def self.html
    `wrap_element(document.body.parentNode)`
  end

  def self.new type = :div
    `wrap_element(document.createElement(type))`
  end

  ##
  # :call-seq:
  #   elm.inspect       -> str
  #
  # Returns a string representation of +self+ which includes the tag name
  # as well as the element `id` and `className`, if present.
  #
  #   Element.body.inspect                  # => <body>
  #   Element.find_by_id('foo').inspect     # => <div id="foo">
  #
  def inspect
    `
      var str = "<" + self.tagName.toLowerCase(), val;

      if (val = self.id) { str += ' id="' + val + '"'; }
      if (val = self.className) { str += ' class="' + val + '"'; }

      return str + '>';
    `
  end

  ##
  # :call-seq:
  #   elm.remove    -> elm
  #
  # Removes the receiver from the document, and then returns it.
  #
  # This will not delete the element, it is just removed from its
  # parent (if one exists) and then returned.
  #
  # Initial html:
  #
  #     <div id="foo">
  #       <p id="bar"></p>
  #       <p id="baz"></p>
  #     </div>
  #
  # Removing the element:
  #
  #     Element.find_by_id('bar').remove
  #     # => <p id="bar">
  #
  # Resulting html:
  #
  #     <div id="foo">
  #       <p id="baz"></p>
  #     </div>
  #
  def remove
    `
      var parent = self.parentNode;

      if (parent) {
        parent.removeChild(self);
      }

      return self;
    `
  end

  ##
  # :call-seq:
  #   elm.empty?    -> true
  #   elm.empty?    -> false
  #
  # Returns +true+ if the element is empty, +false+ otherwise. An
  # element is empty if it doesn't have any child nodes or text
  # content.
  #
  # An element is still empty even if it contains whitespace as
  # whitespace is not counted as content.
  #
  # Usage:
  #
  #     # Given HTML:
  #     #
  #     # <div id="foo">
  #     #   <span id="bar">baz</span>
  #     # </div>
  #
  #     foo = Element.find_by_id 'foo'
  #     bar = Element.find_by_id 'bar'
  #
  #     foo.empty?   # => false
  #     bar.empty?   # => false
  #     bar.clear
  #     bar.empty?   # => true
  #
  def empty?
    /^\s*$/ === @innerHTML
  end

  ##
  # :call-seq:
  #   elm.clear     -> elm
  #
  # Removes all child nodes from the receiver. This will remove both
  # element children as well as plain text nodes, even if they are
  # whitespace.
  #
  # Usage:
  #
  #     # Given HTML:
  #     #
  #     # <div id="some_element">
  #     #   <div></div>
  #     #   <span>Hello</span>
  #     # </div>
  #
  #     Element.find_by_id('some_element').clear
  #     # => <div id="some_element"></div>
  #
  def clear
    `
      var el = self;

      while (el.firstChild) {
        el.removeChild(el.firstChild);
      }

      return self;
    `
  end

  ##
  # :call-seq:
  #   elm.ancestors     -> ary
  #
  # Returns an array of all of +self+ ancestors.
  #
  # The last element will be the top `<html>` element, and the receiver
  # is not included in the returned array. This also means that calling
  # this method on `<html>` will just return an empty array.
  #
  def ancestors
    collect :parentNode
  end

  ##
  # :call-seq:
  #   elm.next_siblings     -> ary
  #
  # Returns an array containing all of +self+ next siblings.
  #
  # Example:
  #
  #     <div id="foo">
  #       <p id="a"></p>
  #       <p id="b">
  #         <span></span>
  #       </p>
  #       <p id="c"></p>
  #       <p id="d"></p>
  #     </div>
  #
  #     Element.find_by_id('b').next_siblings  # => [<p id="c">, <p id="d">]
  #     Element.find_by_id('c').next_siblings  # => [<p id="d">]
  #     Element.find_by_id('d').next_siblings  # => []
  #
  def next_siblings
    collect :nextSibling
  end

  ##
  # :call-seq:
  #   elm.next    -> element
  #
  # Returns this elements next sibling, if one exists. If the receiver
  # does not have a next sibiling then `nil` is returned.
  #
  # Only actual element nodes may be returned, as whitespace or text
  # nodes are ignored.
  #
  # @example
  #
  #     # Given HTML:
  #     #
  #     # <div id="foo">
  #     #   <div id="bar"></div>
  #     #   <div id="baz"></div>
  #     #   <div id="buz"></div>
  #     # </div>
  #
  #     Element.find_by_id('bar').next  # => #<Element id="baz">
  #     Element.find_by_id('baz').next  # => #<Element id="buz">
  #     Element.find_by_id('buz').next  # => nil
  #
  def next
    collect_one :nextSibling
  end

  ##
  # :call-seq:
  #   elm.prev    -> element
  #
  # Returns this elements previous sibling. `nil` is returned if the
  # element does not have a prev sibling.
  #
  # Whitespace and text nodes are not included and will be skipped
  # ensuring that only regular element nodes are returned.
  #
  # @example
  #
  #     # Given HTML:
  #     #
  #     # <div id="foo">
  #     #   <div id="bar"></div>
  #     #   <div id="baz"></div>
  #     #   <div id="buz"></div>
  #     # </div>
  #
  #     Element.find_by_id('bar').prev  # => nil
  #     Element.find_by_id('baz').prev  # => #<Element id="bar">
  #     Element.find_by_id('buz').prev  # => #<Element id="baz">
  #
  def prev
    collect_one :previousSibling
  end

  ##
  # The +id+ attribute of the receiver element. Returns +nil+ if no
  # id is assigned to the element.

  def id
    `self.id`
  end

  def id= id
    `self.id = id`
  end

  def == other
    `self === other`
  end

  def html= str
    `self.innerHTML = str`
  end

  def html
    `self.innerHTML`
  end

  def text
    `self.innerText`
  end

  def append elem
    `self.appendChild(elem)`
  end

  alias_method :<<, :append






  # Returns the tag of the receiver element. This will always be lowercase.
  #
  # @example
  #
  #     # <div id="foo"></div>
  #     Element.find_by_id('foo').tag    # => "div"
  #
  # @return [String] tag name of the receiver
  def tag
    `var tag = self._native.tagName;
    return tag ? tag.toLowerCase() : '';`
  end

  ##
  # :call-seq:
  #   elm[sym]    -> str
  #   elm[sym]    -> nil
  #
  # Returns the value of +self+ attribute named +attribute+, or +nil+ if
  # it does not exist.
  #
  # This method handles any cross browser issues internally.
  #
  # :method: []
  #
  alias_method :[], :get_attribute

  ##
  # :call-seq:
  #   elm.has_class?(name)    -> true
  #   elm.has_class?(name)    -> false
  #
  # Returns +true+ if the receiver has the given class +name+.
  #
  def has_class?(name)
    `
      var full = self.className;

      if (full === name) return true;
      if (full === '') return false;

      return (new RegExp("(^|\\s+)" + name + "(\\s+|$)")).test(full);
    `
  end

  def add_class name
    unless has_class? name
      `self.className += (self.className ? ' ' : '') + name;`
    end

    self
  end

  def remove_class name
    `self.className = self.className.replace(new RegExp("(^|\\s+)" + name + "(\\s+|$)"), '')`
    self
  end

  def class_name
    `self.className`
  end
end
