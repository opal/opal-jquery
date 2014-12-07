if RUBY_ENGINE == "opal"
  require 'opal-jquery/window'
  require 'opal-jquery/document'
  require 'opal-jquery/element'
  require 'opal-jquery/event'
  require 'opal-jquery/http'
  require 'opal-jquery/kernel'
else
  require 'opal'
  require 'opal/jquery/version'

  # do not include dependencies
  Opal.use_gem 'opal-jquery', false
end
