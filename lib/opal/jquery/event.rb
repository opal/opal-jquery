# backtick_javascript: true

require 'opal/jquery/constants'

# {Event} wraps native jQuery events into a ruby api. Instances of events
# can be accessed by {#to_n}.
#
# {Event} instances should not be created directly, as they are usually
# created by one of the dom event handlers in {Element}.
#
#     element.on :click do |event|
#       puts event
#     end
#
#     # => #<Event:0x0000000>
#
# ## Usage
#
# {Event} exposes a slightly different API than jQuery, as {Event} tries to
# add some more ruby flavour to the object.
#
# ### Accessing element triggering event
#
# Unlike jQuery, the context of an event handler is not set to the triggering
# element. Instead, the element triggering the event can be accessed from the
# {Event} instance.
#
# #### Current Target
#
# To access the current element in the bubbling phase, {#element} or
# {#current_target} can be used which is the same as `currentTarget` or `this`
# from jQuery.
#
#     element.on :click do |event|
#       puts "element clicked: #{event.element}
#     end
#
#     # => "element clicked: #<Element: [<div>]>
#
# #### Target
#
# The {#target} of an event is the actual dom element that triggered the event,
# and this will be the same element through all phases of event bubbling. This
# is the same as the `event.target` jQuery property.
#
#     element.on :click do |event|
#       puts "actual element: #{event.target}"
#     end
#
#     # => "actual element: #<Element: [<div>]>
#
# ### Controlling Event Bubbling
#
# Propagation and default behaviour can be controlled on events using {#prevent}
# and {#stop}, which will prevent the browser default and stop event propagation
# respectively.
#
#     element.on :click do |event|
#       event.prevent   # prevent browser default
#       event.stop      # stop event propagation
#     end
#
# If you want to trigger both methods, which is usually the case, then {#kill}
# can be used as a shorthand.
#
#     element.on :click do |event|
#       event.kill
#       puts event.prevented?
#       puts event.stopped?
#     end
#
#     # => true
#     # => true
#
class Event
  `var $ = #{JQUERY_SELECTOR.to_n}` # cache $ for SPEED

  # @private
  # @param native [JSObject] native jquery/javascript event
  def initialize(native)
    @native = native
  end

  # Returns native javascript event created by jQuery.
  #
  # @return [JSObject]
  def to_n
    @native
  end

  def [](name)
    `#@native[name]`
  end

  def type
    `#@native.type`
  end

  # Returns the current element in the bubbling cycle of the event. This is
  # not the same as the actual dom event that triggered the event, but is
  # usually the context element the event was registered with, or the target
  # of the css selector used in newer event styles.
  #
  # @return [Element]
  def element
    `$(#@native.currentTarget)`
  end

  alias current_target element

  # Returns the actual element that triggered the dom event.
  #
  # @return [Element]
  def target
    `$(#@native.target)`
  end

  # Returns `true` if this event has had its default browser behaviour
  # prevented, `false` otherwise.
  #
  # @return [Boolean]
  def prevented?
    `#@native.isDefaultPrevented()`
  end

  # Prevent this event from triggering its default browser behaviour.
  def prevent
    `#@native.preventDefault()`
  end

  # Returns `true` if the propagation/bubbling of this event has been stopped,
  # `false` otherwise.
  #
  # @return [Boolean]
  def stopped?
    `#@native.isPropagationStopped()`
  end

  # Stop further propagaion of this event.
  def stop
    `#@native.stopPropagation()`
  end

  def stop_immediate
    `#@native.stopImmediatePropagation()`
  end

  # Stops propagation and prevents default action.
  #
  # @see {#prevent}
  # @see {#stop}
  def kill
    stop
    prevent
  end

  ##
  # Keyboard/Mouse/Touch

  def page_x
    `#@native.pageX`
  end

  def page_y
    `#@native.pageY`
  end

  def touch_count
    `#@native.originalEvent.touches.length`
  end

  def touch_x(index = 0)
    `#@native.originalEvent.touches[#{index}].pageX` if index < touch_count
  end

  def touch_y(index = 0)
    `#@native.originalEvent.touches[#{index}].pageY` if index < touch_count
  end

  def location
    `#@native.originalEvent.location`
  end

  def ctrl_key
    `#@native.ctrlKey`
  end

  def meta_key
    `#@native.metaKey`
  end

  def alt_key
    `#@native.altKey`
  end

  def shift_key
    `#@native.shiftKey`
  end

  def key_code
    `#@native.keyCode`
  end

  def which
    `#@native.which`
  end

  # @deprecated These will be removed soon
  alias default_prevented? prevented?
  alias prevent_default prevent
  alias propagation_stopped? stopped?
  alias stop_propagation stop
  alias stop_immediate_propagation stop_immediate

end
