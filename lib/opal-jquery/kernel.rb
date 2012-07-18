module Kernel
  def alert(msg)
    `alert(msg)`
    nil
  end

  # @depreciated
  def DOM(selector)
    puts "Kernel#DOM() is now depreciated. Use Document[]"
    Document[selector]
  end
end