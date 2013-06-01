require 'opal'
require 'opal-jquery'

Document.ready? do
  Element.find('#foo').text = "Opal is loaded"
end
