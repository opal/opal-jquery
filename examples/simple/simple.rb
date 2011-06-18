require 'vienna'

# Document.ready? do
  # Element['a'].click do |evt|
    # alert "Thanks for visiting...."
  # end
# end
`opal.browser_repl();`


def try_http
  http = VN::HttpRequest.new("index.html").get
  http.success { puts "successful!"; puts "status: #{http.status}" }
  http.failure { puts "something went wrong :(" }
end

def try_http2
  http = VN::HttpRequest.new("index2.html").get
end

