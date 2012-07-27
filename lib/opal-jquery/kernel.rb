module Kernel
  def alert(msg)
    `alert(msg)`
    nil
  end

  # @depreciated
  def DOM(selector)
    puts "Kernel#DOM() is now depreciated. Use Kernel#query()"
    query(selector)
  end

  def query(selector)
    `$(selector)`
  end
end