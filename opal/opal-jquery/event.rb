require 'opal-jquery/constants'

# Wraps native jQuery event objects.
class Event
  `var $ = #{JQUERY_SELECTOR.to_n}` # cache $ for SPEED

  def initialize(native)
    @native = native
  end

  def [](name)
    `#@native[name]`
  end

  def type
    `#@native.type`
  end

  ##
  # Element

  def current_target
    `$(#@native.currentTarget)`
  end

  def target
    `$(#@native.target)`
  end

  ##
  # Propagation

  def prevented?
    `#@native.isDefaultPrevented()`
  end

  def prevent
    `#@native.preventDefault()`
  end

  def stopped?
    `#@native.isPropagationStopped()`
  end

  def stop
    `#@native.stopPropagation()`
  end

  def stop_immediate
    `#@native.stopImmediatePropagation()`
  end

  # Stops propagation and prevents default action.
  def kill
    stop
    prevent
  end

  # to be removed?
  alias default_prevented? prevented?
  alias prevent_default prevent
  alias propagation_stopped? stopped?
  alias stop_propagation stop
  alias stop_immediate_propagation stop_immediate

  ##
  # Keyboard/Mouse/Touch

  def page_x
    `#@native.pageX`
  end

  def page_y
    `#@native.pageY`
  end

  def touch_x
    `#@native.originalEvent.touches[0].pageX`
  end

  def touch_y
    `#@native.originalEvent.touches[0].pageY`
  end

  def ctrl_key
    `#@native.ctrlKey`
  end

  def key_code
    `#@native.keyCode`
  end

  def which
    `#@native.which`
  end
end
