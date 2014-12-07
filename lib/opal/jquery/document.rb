require 'opal/jquery/constants'
require 'opal/jquery/element'

module Browser
  # {Document} includes these methods to extend {Element}.
  #
  # Generally, you will want to use the {::Document} top level instance of
  # {Element}.
  #
  # ## Usage
  #
  # A useful method on {Document} is the {#ready?} method, which can be used to
  # run a block once the document is ready. This is equivalent to passing a
  # function to the `jQuery` constructor.
  #
  #     Document.ready? do
  #       puts "Page is ready to use!"
  #     end
  #
  # Just like jQuery, multiple blocks may be passed to {#ready?}.
  #
  # ### Document head and body elements
  #
  # Every document has atleast two elements: a `head` and `body`. For
  # convenience, these are both exposed as {#head} and {#body} respectively,
  # and are just instances of {Element}.
  #
  #     puts Document.head
  #     puts Document.body
  #
  #     # => #<Element: [<head>]>
  #     # => #<Element: [<body>]>
  #
  # ### Events
  #
  # {Document} instances also have {#on}, {#off} and {#trigger} methods for
  # handling events. These all just delegate to their respective methods on
  # {Element}, using `document` as the context.
  #
  #     Document.on :click do |evt|
  #       puts "someone clicked somewhere in the document"
  #     end
  #
  module DocumentMethods
    `var $ = #{JQUERY_SELECTOR.to_n}` # cache $ for SPEED

    # Register a block to run once the document/page is ready.
    #
    # @example
    #   Document.ready? do
    #     puts "ready to go"
    #   end
    #
    def ready?(&block)
      `$(#{block})` if block_given?
    end

    # Returns document title.
    #
    # @return [String]
    def title
      `document.title`
    end

    # Set document title.
    #
    # @param title [String]
    def title=(title)
      `document.title = title`
    end

    # {Element} instance wrapping `document.head`.
    #
    # @return [Element]
    def head
      Element.find `document.head`
    end

    # {Element} instance wrapping `document.body`.
    #
    # @return [Element]
    def body
      Element.find `document.body`
    end
  end
end

# Top level {Document} instance wrapping `window.document`.
Document = Element.find(`document`)
Document.send(:extend, Browser::DocumentMethods)

# TODO: this will be removed soon (here for compatibility)
$document = Document
