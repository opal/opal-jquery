require 'vienna'

# Document.ready? do
  # Element['a'].click do |evt|
    # alert "Thanks for visiting...."
  # end
# end
`opal.browser_repl();`


def try_http
  http = VN::HttpRequest.new("index.html").get
  http.success { puts "successful!" }
  http.failure { puts "something went wrong :(" }
end

