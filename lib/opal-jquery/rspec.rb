module Browser
  # When testing (using rspec), this module provides some helper methods to
  # try and make testing a little easier.
  #
  # ## Usage
  #
  # Simply require this file somewher (usualy in `spec_helper.rb`):
  #
  #     require 'application'
  #     require 'opal-rspec'
  #     require 'opal-jquery/rspec'
  #
  # Once required, the module is registered with `rspec` for all example
  # groups.
  #
  # ## Adding html to DOM
  #
  # It is often convenient to have some `HTML` code ready in the dom for
  # testing. This helper method adds the given html string. More so, the html
  # is then removed at the end of each test. This is cruicial as it ensures
  # that the specified html code is inserted before each test, therefore
  # ensuring that html code changed by a test will not affect any other tests
  # in the same scope.
  #
  #     describe "Check DOM code" do
  #       html '<div id="foo"></div>'
  #
  #       it "foo should exist" do
  #         expect(Document['#foo']).to_not be_empty
  #       end
  #     end
  #
  module RSpecHelpers
    # Add some html code to the body tag ready for testing. This will
    # be added before each test, then removed after each test. It is
    # convenient for adding html setup quickly. The code is wrapped
    # inside a div, which is directly inside the body element.
    #
    #     describe "DOM feature" do
    #       html <<-HTML
    #         <div id="foo"></div>
    #       HTML
    #
    #       it "foo should exist" do
    #         Document["#foo"]
    #       end
    #     end
    #
    # @param [String] html_string html content to add
    def html(html_string='')
      html = %Q{<div id="opal-jquery-test-div">#{html_string}</div>}

      before do
        @_spec_html = Element.parse(html)
        @_spec_html.append_to_body
      end

      after { @_spec_html.remove }
    end
  end
end

RSpec.configure do |config|
  config.extend Browser::RSpecHelpers
end
