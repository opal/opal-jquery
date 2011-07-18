require 'rquery/element'

# The `Document` object is an `Element` instance with the native
# document object as its only member. This object is used for performing
# document wide selectors using {Document.[]}.
#
# `Document` also provides the `ready` method which takes a block and
# yields it once the document is fully loaded. This is equivalent to the
# jQuery.ready() function.
Document = `$(document)`

class << Document

  # Top level and main selector entrance point. The given selector
  # string is matched against the document so that any element in
  # the page may be matched. The result is a new RQuery instance
  # which holds all the matched elements, and may also be 0 in
  # length if no elements were matched.
  #
  # @param [String] selector Selector to match against document
  # @return [RQuery]
  def [](selector)
    `return $(selector);`
  end

  # Returns a printable version of the receiver, which is simply
  # 'Document'.
  #
  # @return [String]
  def to_s
    "Document"
  end

  # Returns the title of the document as a string.
  #
  # @return [String]
  def title
    `return document.title;`
  end

  # Sets the document title using the given string.
  #
  # @param [String] str Document title
  # @return [String]
  def title=(str)
    `return document.title = str;`
  end

  # Blocks passed to this method will be called once the document is
  # loaded, or instantly if the document has already loaded. This is
  # useful to hold off DOM manipulation until the runtime can be sure
  # that the document content is fully loaded.
  #
  # @example
  #
  #   puts "pre"
  #
  #   Document.ready do
  #     puts "in ready"
  #   end
  #
  #   puts "post"
  #
  #   # => "pre"
  #   # => "post"
  #   # => "in ready"
  #
  # Asynchronous block calling
  # --------------------------
  #
  # This method is potentially async. If the document is already loaded
  # then the block will be called straight away. If however the document
  # is not loaded, then the block will execute after the code in the
  # containing scope (see example above).
  #
  # @return [self]
  def ready(&blk)
    raise "no block given" unless block_given?

    `var fn = function() {
      opal.run(function(){ #{ blk.call }; });
    };

    self.ready(fn);`

    self
  end
end

