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

  # Handles special cases of method missing. If the method name looks
  # like a element id then it will check the document to see if a
  # matching element is found. If it is, then it is returned as a
  # RQuery instance, otherwise `nil` is returned. If the method name
  # does not look like an element id then super is called which just
  # yields a NoMethodError.
  #
  # @example
  #
  #     Document.some_existing_id     # => [<some_element>]
  #     Document.non_existing_id      # => nil
  #     Document.foo = "bar"          # => NoMethodError
  #
  # @return [RQuery, nil]
  def method_missing(sym, *)
    `var id = #{ sym.to_s };

    if (/^([\w\-]*)$/.test(id)) {
      var el = document.getElementById(id);
      if (!el) return nil;
      return $(el);
    }
    else {
      #{ super sym };
    }`
  end

  def inspect
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
  # @return [self]
  def ready(&blk)
    raise "no block given" unless block_given?

    `var fn = function() {
      #{ blk.call };
    };

    self.ready(fn);`
    self
  end
end

