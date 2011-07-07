# require 'opal_json'

require 'rquery/jquery'

# Wraps native jQuery object and can therefore hold one or more real
# elements. This does NOT subclass Array, but does include the
# Enumerable module for convenience and it does implement many of the
# Array methods. This does not subclass array because the internal
# structure is a lot more complex as each individal element must be
# converted into a jquery instance on reference.
class RQuery
  # include Enumerable

  # Just bridge instances of jQuery to this class.
  native_prototype `$.fn`

  def self.[](selector)
    `return $(selector);`
  end

  # Returns the number of elements in the collection.
  #
  # @return [Numeric]
  def size
    `return self.length;`
  end

  alias_method :length, :size

  def inspect
    `var description = [], elm;

    for (var i = 0, ii = self.length; i < ii; i++) {
      elm = self[i];
      description.push("<" + elm.tagName.toLowerCase() + ">");
    }

    return '[' + description.join(', ') + ']';`
  end
end


require 'rquery/attributes'
require 'rquery/manipulation'
require 'rquery/rquery_events'
require 'rquery/traversing'

require 'rquery/document'

require 'rquery/event'

