Document.ready? do

  # Simple HTTP request which simply gets the content from the given
  # url and sets the inner html content of the div to be the body from
  # the response. No error handling takes place.
  Document['#simple'].on :click do
    HTTP.get "content/data.txt" do |response|
      Document['#simple-result'].html = response.body
    end
  end

  # HTTP request that handles errors. In this case, the target url
  # doesn't exist, so an error is returned instead. All HTTP blocks
  # should really check for bad responses.
  Document['#error'].on :click do
    HTTP.get "content/bad_url" do |response|
      out = Document['#error-result']
      if response.ok?
        out.html = "Something went wrong (should have failed)"
      else
        out.html = "Request failed (as expected)"
      end
    end
  end

  # Parsing JSON Responses
  Document['#json'].on :click do
    HTTP.get("content/users.json") do |response|
      Document['#json-result'].text = response.json.inspect
    end
  end

  # Payload data
  Document['#payload'].on :click do
    data = { first_name: 'Adam', last_name: 'Beynon' }
    HTTP.get("content/users.json", payload: data) do |response|
      Document['#payload-get-result'].text = response.json.inspect
    end
    HTTP.post("content/users.json", payload: data) do |response|
      Document['#payload-post-result'].text = response.json.inspect
    end
  end
end