class Event
  def initialize(event)
    @event = event
  end
  def [](name)
    `#{@event}[name]`
  end

  def ctrl_key
    `#{@event}.ctrlKey`
  end

  def current_target
    `$(#{@event}.currentTarget)`
  end

  def default_prevented?
    `#{@event}.isDefaultPrevented()`
  end

  # Stops propagation and prevents default action.
  def kill
    stop_propagation
    prevent_default
  end

  def prevent_default
    `#{@event}.preventDefault()`
  end

  def page_x
    `#{@event}.pageX`
  end

  def page_y
    `#{@event}.pageY`
  end

  def propagation_stopped?
    `#{@event}.propagationStopped()`
  end

  def stop_propagation
    `#{@event}.stopPropagation()`
  end

  def stop_immediate_propagation
    `#{@event}.stopImmediatePropagation()`
  end

  def target
    `$(#{@event}.target)`
  end

  def touch_x
    `#{@event}.originalEvent.touches[0].pageX`
  end

  def touch_y
    `#{@event}.originalEvent.touches[0].pageY`
  end

  def type
    `#{@event}.type`
  end

  def which
    `#{@event}.which`
  end
end
