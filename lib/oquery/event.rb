class Event < `$.Event`
  def current_target
    %x{
      return $(#{self}.currentTarget);
    }
  end

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
end