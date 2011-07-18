# Represents a collection of actual elements, not always just 1. This is
# the same as a jQuery of zepto instance which may contain 0, 1, or many
# actual elements.
class Element

  # Make instances toll free to native jquery/zepto instances
  native_prototype `$.fn`

  # Returns the number of actual elements in this collection.
  #
  # @return [Numeric]
  def size
    `return self.length;`
  end

  alias_method :length, :size

  # Returns a string representation of the receiver.
  #
  # @return [String]
  def to_s
    `var description = [], elm;

    for (var i = 0, ii = self.length; i < ii; i++) {
      elm = self[i];
      description.push('<' + elm.tagName.toLowerCase() + '>');
    }

    return '[' + description.join(', ') + ']';`
  end

  # @group Traversing

  # Returns a new Element instance with the element at the given index
  # as the only member. The `index` may be nagative, in which case the
  # index will be counted from the end of the collection. If there is no
  # member at the requested index then `nil` is returned.
  #
  # @param [Numeric] index The index to retrieve
  # @return [Element, nil]
  def at(index)
    `var size = self.length;

    if (index < 0) index += size;
    if (index < 0 || index >= size) return nil;
    return $(self[index]);`
  end

  # @endgroup

  # @group Manipulation

  # Returns the text content of the first member in this collection.
  #
  # @return [String]
  def text
    `return self.text() || '';`
  end

  # Set the text content of all the members in the receiver.
  #
  # @param [String] str String content to set
  # @return [String]
  def text=(str)
    `self.text(str);
    return str;`
  end

  # Returns the inner html of the first member in this collection as a
  # string. If this is empty then an empty string is returned.
  #
  # @return [String]
  def html
    `return self.html() || '';`
  end

  # Sets the inner html of all the members in this collection to the
  # given string representing the html. This is set on all members.
  #
  # @param [String] str The html string to set
  # @return [String]
  def html=(str)
    `self.html(str);
    return str;`
  end

  # @endgroup

  # @group Event handlers

  [:click, :mousedown, :mouseup].each do |evt|
    define_method(evt) do |&block|
      bind evt, &block
    end
  end

  def bind(event, &block)
    raise "Element#bind - no block given" unless block_given?

    `var handler = function() {
      opal.run(function() {#{ block.call }; });
    };

    self.bind(#{ event.to_s }, handler);`

    block
  end

  # @endgroup
end

