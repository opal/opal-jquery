module Kernel
  def alert(msg)
    `alert(msg)`
    nil
  end
end