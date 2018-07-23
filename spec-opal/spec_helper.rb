require 'jquery/jquery-1.8.3'
require 'opal-rspec'
require 'opal/jquery'
require 'opal/jquery/rspec'

module JQueryTestHelpers
  def find(selector)
    Element.find selector
  end
end

module SkipAsync
  def async(*args, &block)
    xit(*args, &block)
  end
end

RSpec.configure do |config|
  config.include JQueryTestHelpers
  config.extend SkipAsync
  config.formatter = :doc
  config.color = true
end
