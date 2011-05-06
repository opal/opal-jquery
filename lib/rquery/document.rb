require 'rquery/element'

module RQuery

  # The core methods on the `Document` object are provided by the
  # {DocumentMethods} module. This module is `included` into Document to
  # become available on `Document` itself, or its global alternative
  # `$document`.
  #
  # Document is essentially an instance of element, so these methods are
  # just additional instance methods for Document.
  module DocumentMethods

    # Accepts a block that will be called once the document is ready. This uses
    # the underlying $(function() { ... }) mechanism. Note, multiple blocks may
    # be passed to this function and they will be called in order.
    #
    # @example
    #
    #     Document.ready? do
    #       puts "document is now ready"
    #     end
    #
    # @return [Document] returns self 
    def ready?
      `$(function() { #{yield}; })` if block_given?
     self
    end

    # Returns an {Element} representing the <head> element of the page.
    #
    # @return {Element} head element
    def head
      `return $(document.getElementsByTagName('head')[0]);`
    end

    # Returns an {Element} representing the <body> element of the page.
    #
    # @returns {Element} Body element
    def body
      `return $(document.getElementsByTagName('body')[0]);`
    end

    # Returns the string title of the document. Will be an empty string
    # if the title is not yet loaded (which it should be).
    #
    # @return [String]
    def title
      `return document.title;`
    end

    def [](selector = nil)
      Element.find selector
    end

    alias_method :find, :[]
  end

  Document = `$(document)`
  Document.extend DocumentMethods
end

# The global variable `$document` is the main variable that should be
# used when accessing the document with selectors.
$document = RQuery::Document

