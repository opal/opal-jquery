require 'rquery/css'
require 'rquery/dom_events'

module RQuery

  # Element is used two-fold. It is the equivalent of the jQuery object in js,
  # and is used to create new element literals. Therefore, an Element instance
  # can actually represent 1, many, or even 0 actual elements. Element for this
  # reason is actually more like an array of elements, where its instance 
  # methods are applied to 0 or more actual elements. Accessing elements 
  # individually through {#first} etc, still returns an Element instance with
  # a singular element literal.
  class Element

    include Enumerable
    include CSS
    include DOMEvents

    # jQuery objects themselves are bridged to the ruby Element class. This allows
    # direct access to jquery through ruby, and makes the creation and accessing of
    # jquery objects really fast and efficient (there is minimal overhead introduced
    # by wrapping them).
    #
    # This is accomplished basically by adding the requied opal properties onto jquery
    # as if they were just plugins; $m, $klass and $flags. These are the same names as
    # added to the core prototypes as to avoid name confliction as much as possible.
    native_prototype `$.fn`

    # Top level selector. This is the equivalent of passing a selector string
    # to the jQuery object. This searches essentially in the context of the
    # document, and returns an Element instance with all matched elements.
    #
    # @example
    #
    #     Element.find 'div > p'
    #     # => #<Element 0x91232>
    #
    # @param [String] selector
    # @return [Element]
    def self.find(selector)
      `return $(selector);`
    end

    # alias_method :[], :find

    # Initialze is used when simply creating a new Element, the equivalent of
    # document.createElement('tagName'). It is then wrapped by jquery and
    # becomes the sole element belonging to this instance.
    #
    # Creating a new Element instance should only be used when actually creating
    # a new DOM element. For referencing already existing elements, instead use
    # one of the selector methods, {Element#find} etc.
    #
    # **NOTE** initialize is not used due to limitations on creating/adding to
    # jquery objects, so we need to override {.new} instead.
    #
    # @return [Element]
    def self.new(type = 'div')
      `return $(document.createElement(type));`
    end

    # Find the given selector within the content if this Element. This is the
    # equivalent of passing a selector to the receivers native jQuery object
    # so that only elements within the scope of the receiver will be selected.
    #
    # @param [String] selector
    # @return [Element]
    def find(selector)
      `return self.find(selector);`
    end

    # Returns a string representation of the collection of elements. If the
    # receiver contains a single element, then it will display the tag name,
    # id and class of the receiver. If more than one element is present, then
    # the inspection string will just contain the number of contained elements.
    #
    # @return [String]
    def to_s
      if length == 1
        str = "#<Element #{tag}"
        str += ", id=#{id.inspect}" if id
        str + ">"
      else
        "#<Element selector=#{selector.inspect} length=#{length}>"
      end
    end

    # Returns the tag name of the receiver. All tag names are in lowercase and
    # will overcome any cross browser differences. If there are no elements in
    # the receiver then the tag name will be an empty string. If there are more
    # than one elements, the tag name will be that of the first element in the
    # collection.
    #
    # @return [String]
    def tag
      `return self[0] ? self[0].tagName.toLowerCase() : '';`
    end

    # Returns the number of elements in the receiver.
    #
    # @return [Numeric]
    def length
      `return self.length;`
    end

    alias_method :size, :length

    # Indexed reference - Returns the matched element at the given index, or
    # returns a slice of elements beginning at the given index for the given
    # count of elements. Negative indecies count backwards from the end of the
    # set of matched elements, so that -1 would be the last matched element.
    # This will return nil if the given index is not in range.
    #
    # TODO: count functionality not yet implemented - only simple index
    # referencing.
    #
    # @param [Numeric] index index to start at
    # @param [Numeric] count last index
    # @return [Element, nil]
    def [](index, count = nil)
      `var size = self.length;

      if (index < 0) index += size;

      if (index >= size || index < 0) return nil;

      return $(self[index]);`
    end

    # Returns the original selector passed to find the elements. If no selector
    # was given, for example when creating a new object literal, or by passing
    # in a current element, then the selector will just be an empty string.
    #
    # @return [String]
    def selector
      `return self.selector;`
    end

    # Yields the block for each matched element in the receiver. The block is
    # passed the element as the first param, and the index as the second.
    #
    # @example
    #
    #     Element.find('div').each do |elem, idx|
    #       puts "at idx #{idx} we found: #{elem}."
    #     end
    #
    # @return [Element] returns the receiver
    def each
      `var length = self.length;

      for (var i = 0; i < length; i++) {
        try {
          #{yield `$(self[i])`, `i`};
        } catch (e) {
          throw e;
        }
      }

      return self;`
    end

    # Yields the `block` once for each element in the receiver. Returns a new
    # Array containing the values returned by the block.
    #
    # **NOTE** This differers from jquerys' implementation in that this method
    # will always return an array, which may include Element instances, but
    # may contain any object type.
    #
    # @example HTML
    #
    #     !!!plain
    #     <body>
    #       <p id="first">Some content</p>
    #       <p id="second">Some more content</p>
    #       <p id="third">Nearly done</p>
    #       <p id="forth">Last of the content</p>
    #     </body>
    # 
    # @example Ruby
    #
    #     Document['p'].map { |e| [e.id, e.html] }
    #     # => [['first',  'Some content'],
    #           ['second', 'Some more content'],
    #           ['third',  'Nearly done'],
    #           ['forth,   'Last of the content']]
    #
    # @return [Array]
    def map
      `var result = [];

      for (var i = 0, length = self.length; i < length; i++) {
        try {
          result.push(#{yield `$(self[i])`, `i`});
        } catch (e) {
          throw e;
        }
      }

      return result;`
    end

    alias_method :collect, :map

    # Returns a new instance containing the siblings immediately following
    # those contained within this instance. An optional `selector` may be
    # passed so that the sibling is only returned if it matches the given
    # selector.
    #
    # @example HTML
    #
    #     !!!plain
    #     <ul>
    #       <li class="first">First item</li>
    #       <li>First subitem</li>
    #     </ul>
    #     <ul>
    #       <li class="first">More options</li>
    #       <li class="foo">Second options</li>
    #     </ul>
    #
    # @example Ruby
    #
    #     Document['li.first'].next
    #     # => #<Element length=2 selector="li.first.next()">
    #
    #     Document['li.first'].next '.foo'
    #     # => #<Element li>
    #
    # @param {String} selector The optional selector to use
    # @return {Element}
    def next(selector = nil)
      if selector
        `return self.next(selector);`
      else
        `return self.next();`
      end
    end

    alias_method :succ, :next

    # Returns a new instance containing elements immediately before each of
    # those within this context. The optional `selector` may be used to
    # filter the results by the elements which only match the given selector.
    #
    # @example HTML
    #
    #     !!!plain
    #     <ul>
    #       <li>First item</li>
    #       <li class="foo">First subitem</li>
    #     </ul>
    #     <ul>
    #       <li class="bar">More options</li>
    #       <li class="foo">Second options</li>
    #     </ul>
    #
    # @example Ruby
    #
    #     Document['li.foo'].prev
    #     # => #<Element length=2 selector="li.foo.prev()">
    #
    #     Document['li.foo'].prev '.bar'
    #     # => #<Element li>
    #
    # @param {String} selector The selector to match
    # @return {Element}
    def pred(selector = nil)
      if selector
        `return self.prev(selector);`
      else
        `return self.prev();`
      end
    end

    alias_method :prev, :pred

    # Get or set the value of an attribute for the first element in this set of
    # matched elements. This will only happen for the first matched element, so
    # to apply this to all matches, use {#each} or loop over each item with
    # another construct.
    #
    #
    def attr(name, value = nil)
      if value.nil?
        `self.attr(#{name.to_s}) || ''`
      else
        `self.attr(#{name.to_s}, value)`
      end
    end

    # Returns the id attr of the first matched element. If the set of elements
    # is empty, then nil is just returned. An optional value may be passed
    # which will be set as the id of the first element. This is the same as
    # setting the id with {#id=} but this allows for chained calls, and it also
    # returns the receiver (to allow for chained calls).
    #
    # @example Retrieving the id
    #
    #     Element['div'].id
    #     # => 'some_id'
    #
    # @example Setting the id
    #
    #     Element['div'].id('new_id')
    #     # => #<Element 0x827>
    #
    # @param [String] value optional id to set
    # @return [Element, String]
    def id(value = nil)
      if value
        `return self.attr('id', value);`
        self
      else
        `return self.attr('id') || nil;`
      end
    end

    # Sets the id of the first matched element in the receiver.
    #
    # @example
    #
    #     Element['div].id = "some_new_id"
    #
    # @param [String] value the id to set
    # @return [String] returns the set value
    def id=(value)
      `self.attr('id', value);`
      value
    end

    # Returns the html content of the first matched element in the receiver.
    # If the optional `content` is given, then this will set the html content
    # in the same manner than {#html=} does, except that this method will
    # return the receiver so that it can be used for chaining calls.
    #
    def html(content = nil)
      if content
        `return self.html(content);`
      else
        `return self.html();`
      end
    end

    def html=(content)
      `return self.html(content);`
    end

    def text(content = nil)
      `return self.text();`
    end

    # Sets the value for each element in this context of matched elements.
    # This method is used to set the value of elements in form fields such
    # as text inputs.
    #
    # @example HTML
    #
    #     !!!plain
    #     <button>First</button>
    #     <button>Second</button>
    #     <button>Third</button>
    #     <input id="output type="text"></input>
    #
    # @example Ruby
    #
    #     Document['button'].click do |evt|
    #       Document['#output'].value = evt.target.text
    #     end
    #
    # @param {String} str The value to set
    # @return {String} returns newly set value
    def value=(str)
      `self.val(str);`
      str
    end

    # Return the first matched element in the receiver.
    #
    # @return [Element]
    def first
      `return self.first();`
    end

    # Remove all the child nodes from each of the matched elements in the
    # receiver. This method will remove all text contents of the receiver
    # as well, as they are also text nodes belonging to the receiver. By
    # using jQuery underpinnings, all event listeners of all children are
    # also removed first to avoid memory leaks.
    #
    # @return [Element] returns the receiver
    def clear
      `return self.empty();`
    end

    alias_method :empty, :clear

    # Removes the set of matched elements from the DOM. This method works 
    # similarly to {#clear}, but the matched element is also removed, as well
    # as its children. Also, like {#clear}, all event handlers are removed
    # first. An optional selector may be passed which removes those children
    # of the matched elements that match the given selector.
    #
    # @return [Element] returns the receiver
    def remove
      `return self.remove();`
    end

    # Inserts the given content to the end of each element in the set
    # represented by the receiver.
    #
    # @param [String, Element] content content to insert
    # @return [Element] returns the receiver
    def append(content)
      `return self.append(content);`
    end

    alias_method :<<, :append

    # Inserts the given `content` before each member in the receiver. The
    # content may be a string, or an element.
    #
    # @param [String, Element] content the content to insert
    # @return [Element] returns the receiver
    def before(content)
      `return self.before(content);`
    end

    # Inserts the `content` before each member in the receiver. Content
    # may be a string or an Element instance.
    #
    # @param [String, Element] content content to insert
    # @return [Element] returns the receiver
    def after(content)
      `return self.after(content);`
    end
  end
end

