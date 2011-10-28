class Element
  ##
  # The +id+ attribute of the receiver element. Returns +nil+ if no
  # id is assigned to the element.

  attr_accessor :id

  ##
  # Search the document for an element with the given id. If found,
  # it is returned. If one cannot be found then `nil` is returned
  # instead.
  #
  #     Element.find_by_id :foo     # => #<Element:0x000000>
  #     Element.find_by_id :bar     # => nil

  def self.find_by_id id
    `var elm = document.getElementById(id);

    if (elm) { return #{ from_native `elm` }; }

    return nil;`
  end

  def self.body
    @body ||= self.from_native `document.body`
  end

  def self.html
    @html ||= self.from_native `document.body.parentNode`
  end

  def self.new type = :div
    self.from_native `document.createElement(type)`
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
    `var str = "<" + self.tagName.toLowerCase(), val;

    if (val = self.id) { str += ' id="' + val + '"'; }
    if (val = self.className) { str += ' class="' + val + '"'; }

    return str + '>';`
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
    `var parent = self.parentNode;

    if (parent) {
      parent.removeChild(self);
    }

    return self;`
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
    `var el = self;
    while (el.firstChild) { el.removeChild(el.firstChild); }
    return self;`
  end

  ##
  # :call-seq:
  #   elm.collect(sym)      -> ary
  #
  # Returns an array of all elements relative to +self+. +prop+ should
  # be a native property name of the receiver element that points to a
  # relative element (e.g. `parentNode`).
  #
  #   elm.collect(:parentNode)
  #   # => [<body>, <html>]
  #
  def collect prop
    `var elem = self, result = [];

    while (elem = elem[prop]) {
      if (elem.nodeType === 1) {
        result.push( #{ Element.from_native `elem` } );
      }
    }

    return result;`
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
    `var elm = self._native.nextSibling;

    while (elm) {
      if (elm.nodeType == 1) {
        return #{ Element.from_native `elm` };
      }
      elm = elm.nextSibling;
    }

    return nil;`
  end

  def == other
    `self === other`
  end

  def html= html
    @innerHTML = html
  end

  def append elem
    `self.appendChild(elem)`
  end

  alias_method :<<, :append





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
  # @return [Element] previous element
  def prev
    `var elm = self._native.previousSibling;

    while (elm) {
      if (elm.nodeType == 1) {
        return #{ Element.from_native `elm` };
      }
      elm = elm.previousSibling;
    }

    return nil;`
  end

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
end
