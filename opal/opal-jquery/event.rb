# Wraps native jQuery event objects.
class Event
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

  def default_prevented?
    `#@native.isDefaultPrevented()`
  end

  def prevent_default
    `#@native.preventDefault()`
  end

  def propagation_stopped?
    `#@native.propagationStopped()`
  end

  def stop_propagation
    `#@native.stopPropagation()`
  end

  def stop_immediate_propagation
    `#@native.stopImmediatePropagation()`
  end

  # Stops propagation and prevents default action.
  def kill
    stop_propagation
    prevent_default
  end

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
