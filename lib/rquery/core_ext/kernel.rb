module Kernel

  def alert(str)
    `alert(str);`
    self
  end

  def rquery(selector = nil)
    if block_given?
      raise "Kernel#rquery: need to handle rquery.ready?"
    elsif selector
      RQuery.find selector
    else
      RQuery
    end
  end
end

