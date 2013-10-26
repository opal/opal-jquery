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

  def type
    @type
  end


  # Element

  def current_target
    `$(#{self}.currentTarget)`
  end

  def target
    `$(#{self}.target)`
  end


  # Propagation

  def default_prevented?
    `#{self}.isDefaultPrevented()`
  end

  # Stops propagation and prevents default action.
  def kill
    stop_propagation
    prevent_default
  end

  alias_native :prevent_default, :preventDefault

  alias_native :propagation_stopped?, :propagationStopped

  alias_native :stop_propagation, :stopPropagation

  alias_native :stop_immediate_propagation, :stopImmediatePropagation

  # Keyboard/Mouse/Touch

  def page_x
    @pageX
  end

  def page_y
    @pageY
  end

  def touch_x
    `#{self}.originalEvent.touches[0].pageX`
  end

  def touch_y
    `#{self}.originalEvent.touches[0].pageY`
  end

  def ctrl_key
    @ctrlKey
  end

  def key_code
    @keyCode
  end

  def which
    @which
  end
end
