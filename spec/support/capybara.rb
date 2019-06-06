require 'opal'
require 'capybara/rspec'
require 'opal/simple_server'

Capybara.save_and_open_page_path = "#{__dir__}/tmp"

Opal.append_path "#{__dir__}/app"

jquery_version = ENV['JQUERY_VERSION'] || '3'

Capybara.app = Opal::SimpleServer.new { |s|
  s.main = "application-v#{jquery_version}"
}

require 'capybara/apparition'
Capybara.default_driver = :apparition
Capybara.javascript_driver = :apparition

Capybara.register_server :puma do |app, port, host|
  require 'rack/handler/puma'
  Rack::Handler::Puma.run(app, Host: host, Port: port, Threads: "0:4", Silent: true)
end

module OpalHelper
  def compile_opal(code)
    Opal.compile(code, requireable: false)
  end

  def execute_opal(code)
    execute_script compile_opal(code)
  end

  def evaluate_opal(code)
    # Remove the initial comment that prevents evaluate from worning
    evaluate_script compile_opal(code).strip.lines[1..-1].join("\n")
  end

  def opal_nil
    @opal_nil ||= evaluate_opal 'nil'
  end
end

RSpec.configure do |config|
  config.before(:each) do
    visit '/'
    sleep 0.05 until evaluate_script('document.readyState') == 'complete'
  end

  config.include OpalHelper
  config.include Capybara::DSL
  config.include Capybara::RSpecMatchers
end
