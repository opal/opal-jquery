#= require opal-spec
#= require opal-jquery
#= require_self
#= require_tree .

module OpalSpec
  class ExampleGroup

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
      html = '<div id="opal-jquery-test-div">' + html_string + '</div>'
      before do
        @__html = Document.parse(html)
        @__html.append_to_body
      end

      after { @__html.remove }
    end
  end
end

OpalSpec::Runner.autorun
