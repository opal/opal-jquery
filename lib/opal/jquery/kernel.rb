# backtick_javascript: true

module Kernel
  # Alert the given message using `window.alert()`. This is a blocking
  # method.
  #
  # @param msg [String] message to alert
  # @return [nil]
  def alert(msg)
    `alert(msg)`
    nil
  end
end
