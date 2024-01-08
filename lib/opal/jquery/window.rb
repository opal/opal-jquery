# backtick_javascript: true

require 'opal/jquery/element'

module Browser
  # {Window} instances are {Native} objects used to wrap native window instances.
  #
  # Generally, you will want to use the top level {::Window} instance, which
  # wraps `window` from the main page.
  class Window
    # In more recent Opal versions Native::Wrapper should be used
    include defined?(Native::Wrapper) ? Native::Wrapper : Native

    # Returns this {Window} instance wrapped as an {Element}. Useful for
    # delegating jQuery events, which allows the use of `window` as target.
    #
    # @return [Element]
    def element
      @element ||= Element.find(`window`)
    end

    # @see Element#on
    def on(*args, &block)
      element.on(*args, &block)
    end

    # @see Element#off
    def off(*args, &block)
      element.off(*args, &block)
    end

    # @see Element#trigger
    def trigger(*args)
      element.trigger(*args)
    end
  end
end

# Top level {Browser::Window} instance.
Window = Browser::Window.new(`window`)

# TODO: this will be removed soon.
$window = Window
