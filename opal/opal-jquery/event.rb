#Class.bridge_class 'Event', `$.Event`

# Wraps native jQuery event objects.
class Event
  %x{
    var bridge_class = $.Event;

    #{self}._proto = bridge_class.prototype, def = #{self}._proto;
    bridge_class.prototype._klass = #{self};
  }

  include Kernel

  def [](name)
    `#{self}[name]`
  end

  def ctrl_key
    @ctrlKey
  end

  def current_target
    `$(#{self}.currentTarget)`
  end

  def default_prevented?
    `#{self}.isDefaultPrevented()`
  end

  # Stops propagation and prevents default action.
  def kill
    stop_propagation
    prevent_default
  end

  alias_native :prevent_default, :preventDefault

  def page_x
    `#{self}.pageX`
  end

  def page_y
    `#{self}.pageY`
  end

  alias_native :propagation_stopped?, :propagationStopped

  alias_native :stop_propagation, :stopPropagation

  alias_native :stop_immediate_propagation, :stopImmediatePropagation

  def target
    `$(#{self}.target)`
  end

  def touch_x
    `#{self}.originalEvent.touches[0].pageX`
  end

  def touch_y
    `#{self}.originalEvent.touches[0].pageY`
  end

  def type
    @type
  end

  def which
    @which
  end
end
