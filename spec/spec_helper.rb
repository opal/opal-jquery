require 'jquery/jquery-1.8.3'
require 'opal-rspec'
require 'opal/jquery'
require 'opal/jquery/rspec'

module JQueryTestHelpers
  def find(selector)
    Element.find selector
  end
end

RSpec.configure do |config|
  config.include JQueryTestHelpers
  config.formatter = :doc
end
