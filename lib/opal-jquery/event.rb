class Event < `$.Event`
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

  def target
    %x{
      if (#{self}._opalTarget) {
        return #{self}._opalTarget;
      }

      return #{self}._opalTarget = $(#{self}.target);
    }
  end

  def type
    `#{self}.type`
  end

  def which
    `#{self}.which`
  end
end

