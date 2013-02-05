# Wraps native jQuery event objects.
class Event < `$.Event`
  def [](name)
    `#{self}[name]`
  end

  def current_target
    `$(#{self}.currentTarget)`
  end

  alias_native :default_prevented?, :isDefaultPrevented

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

  def type
    `#{self}.type`
  end

  def which
    `#{self}.which`
  end
end
