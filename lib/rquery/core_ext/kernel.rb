module Kernel

  def alert(str)
    `alert(str);`
    self
  end
end

