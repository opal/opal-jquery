require 'bundler'
Bundler.require

run Opal::Server.new { |s|
  s.main = 'opal/rspec/sprockets_runner'
  s.append_path 'spec'
  s.debug = false
  s.index_path = 'spec/jquery/index.html'
}

