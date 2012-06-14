module Kernel
  def alert(msg)
    `alert(msg)`
    nil
  end

  # The `DOM` method is identical to jquery/zepto's `$()` function. It
  # can be used to find elements by their id, perform a general CSS
  # selector search over the document, or indeed parse an HTML string
  # into a useable element instance.
  #
  # @example
  #   # search for an element by id
  #   DOM('#foo')                 => [<div id="foo">]
  #
  #   # search for all matching elements
  #   DOM('.bar')                 => [<p class="bar">, <p class="bar">]
  #
  #   # parse html string into element
  #   DOM('<p id="baz">Hey</p>')  => [<p id="baz">] 
  #
  # @param [String] selector selector to search for or html string
  # @return [DOM] returns element instance which may be empty
  def DOM(selector)
    `$(selector)`
  end
end