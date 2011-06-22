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

def try_http_new
  http = VN::HttpRequest.new.get "index.html"
end

def try_http_newer
  http = VN::HttpRequest.get "index.html"
end

class PageLoader

  def initialize
    @request = req = VN::HttpRequest.new
    req.success { request_succeeded req }
    req.failure { request_failed req }
  end
end
