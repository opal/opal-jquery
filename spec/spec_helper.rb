# make sure these tests are indeed running inside opal, not any other
# ruby engine.
unless RUBY_ENGINE =~ /opal-browser/
  abort "rquery tests **must** be run in the browser"
end

require 'rquery'
require 'opaltest/spec'
require 'opaltest/autorun'

if $0 == __FILE__
  Dir['spec/**/*.rb'].each { |spec| require spec }
end
