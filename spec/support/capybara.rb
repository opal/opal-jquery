require 'opal'
require 'capybara/rspec'
require 'opal/simple_server'

Opal.append_path "#{__dir__}/../app"
Capybara.app = Opal::SimpleServer.new { |s|
  s.index_path
}

require 'capybara/apparition'
Capybara.default_driver = :apparition
Capybara.javascript_driver = :apparition

