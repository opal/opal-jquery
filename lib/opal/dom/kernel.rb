module Kernel
  def alert(msg)
    `alert(msg)`
    nil
  end

  def DOM(selector)
    `$(selector)`
  end
end