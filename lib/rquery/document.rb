require 'rquery/element'

Document = Element.from_native `document`

class << Document
  attr_accessor :title

  ##
  # :call-seq:
  #   Document.ready? {}  -> Document
  #   Document.ready?     -> true
  #   Document.ready?     -> false
  #
  def ready?(&block)
    if block_given?
      at_exit(&block)
    else
      raise "Must pass block to Document.ready? ... (for now)"
    end
  end
end
