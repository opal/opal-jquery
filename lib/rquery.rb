require 'json'

# RQuery wraps around the jquery library to provide a ruby api for DOM
# manipulation. Core classes and modules are contained in this module,
# so `include` it to bring these into the top level scope.`
module RQuery

end

require 'rquery/jquery'
require 'rquery/element'
require 'rquery/document'
require 'rquery/event'
require 'rquery/request'
require 'rquery/response'

require 'rquery/ext/kernel'

