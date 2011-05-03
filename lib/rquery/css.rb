module RQuery

  # This module provides support for elements to get, set and modify
  # their style properties. This module is included into {Element}
  # directly.
  module CSS

    # Adds the given class or classes to each element in the receiver. Multiple
    # classes may be added by seperating them with a space. These classes do not
    # replace any previously set classes, but are instead added.
    #
    # @example HTML
    #
    #     !!!plain
    #     <ul>
    #       <li>First</li>
    #       <li>Second</li>
    #       <li>Third</li>
    #     </ul>
    #
    # @example Ruby
    #
    #     Document['li:last'].add_class 'selected'
    #
    # @example Result
    #
    #     !!!plain
    #     <ul>
    #       <li>First</li>
    #       <li>Second</li>
    #       <li class="selected">Third</li>
    #     </ul>
    #
    # @param [String] name the class(es) name(s)
    # @return [Element] returns the receiver
    def add_class(name)
      `return self.addClass(name);`
    end

    # Removes the given class or classes to each element in the receiver. Multiple
    # classes may be removed at once by passing in a space seperated string of
    # classnames. To remove all classes, don't pass in a parameter, which will
    # remove all set classes.
    #
    # @example HTML
    #
    #     !!!plain
    #     <p class="foo bar">First paragraph</p>
    #     <p class="foo bar">Second paragraph</p>
    #
    # @example Ruby
    #
    #     Document['p:first'].remove_class 'foo'
    #     Document['p:last'].remove_class
    #
    # @example Result
    #
    #     !!!plain
    #     <p class="bar">First paragraph</p>
    #     <p>Second paragraph</p>
    # 
    # @param [String] name the classes to remove
    # @return [Element] returns the receiver
    def remove_class(name = nil)
      if name
        `return self.removeClass(name);`
      else
        `return self.removeClass();`
      end
    end

    # This method determines whether any of the elements within the receivers'
    # context contain the given class name.
    #
    # HTML elements may have more than once class assigned to them, and this is
    # represented by a space between the class names:
    #
    #     !!!plain
    #     <div id="title" class="selected blue"></div>
    #
    # This method will return `true` if the given class `name` is assigned to
    # one of the elements in this receiver, even if other classes are also
    # present. Given the HTML string above:
    #
    #     Document['#title'].has_class? 'selected'
    #     # => true
    #
    #     Document['#title'].has_class? 'blue'
    #     # => true
    #
    # If the classname is not present in the receiver, `false` is returned:
    #
    #     Document['#title'].has_class? 'red'
    #     # => false
    #
    # @param [String] name class name to check for
    # @return [true, false]
    def has_class?(name)
      `return self.hasClass(name) ? Qtrue : Qfalse;`
    end

    def style
      @style ||= StyleHash.new self
    end

    alias_method :css, :style

    # The `StyleHash` class is a simple object that catches all `reader` and
    # `writer` methods to get or set css properties on the receiver element.
    # An instance of this class is created by the {CSS#style} method, which
    # sets the element instance on this class. {#[]} and {#[]=} can also be
    # used to set or retrieve element properties.
    #
    # Getting the StyleHash instance for the element:
    #
    #     Document['#title'].style
    #     # => #<StyleHash:#<Element id="title">>
    #
    # Setting properties:
    #
    #     elem = Document['#title']
    #     elem.style.background_color = 'blue'    # => 'blue'
    #     elem.style['color'] = 'red'             # => 'red'
    #
    # Getting properties
    #
    #     elem = Document['#title']
    #     elem.style.background_color             # => 'blue'
    #     elem.style['color']                     # => 'red'
    #
    # CSS property names should all be `snake_case`. The names are converted
    # into jquery ready names internally by replacing each '_' with '-'. This
    # allows full ruby compatible setter names like `background_color=` to be
    # used.
    class StyleHash < BasicObject

      def initialize(element)
        `return self.$element = element;`
      end

      def [](property)
        `property = property.replace('_', '-');
        return self.$element.css(property);`
      end

      def []=(property, value)
        `property = property.replace('_', '-');
        self.$element.css(property, value);
        return value;`
      end

      def method_missing(property, value = nil)
        `if (value == nil) {
          property = property.replace('_', '-');
          return self.$element.css(property);
        }
        else {
          property = property.substr(0, property.length - 1).replace('_', '-');
          self.$element.css(property, value);
          return value;
        }`
      end

      def inspect
        to_s
      end

      def to_s
        "#<StyleHash:#{`self.$element`.inspect}>"
      end
    end # StyleHash
  end
end

