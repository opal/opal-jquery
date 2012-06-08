require 'rquery'

Document.ready? do

  # Simple HTTP request which simply gets the content from the given
  # url and sets the inner html content of the div to be the body from
  # the response. No error handling takes place.
  DOM.id('simple').on :click do
    HTTP.get "content/data.txt" do |response|
      DOM.id('simple-result').html = response.body
    end
  end

  # HTTP request that handles errors. In this case, the target url
  # doesn't exist, so an error is returned instead. All HTTP blocks
  # should really check for bad responses.
  DOM.id('error').on :click do
    HTTP.get "content/bad_url" do |response|
      out = DOM.id 'error-result'
      if response.ok?
        out.html = "Something went wrong (should have failed)"
      else
        out.html = "Request failed (as expected)"
      end
    end
  end
end