require 'rquery/native_dom_events'

module DOMEvents

  def observe(name, &block)
    __observe__ name, block
  end
end
