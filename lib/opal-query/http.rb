class HTTP
  attr_reader :body
  attr_reader :error_message
  attr_reader :method
  attr_reader :status_code
  attr_reader :url
  
  def self.get(url, opts={}, &block)
    self.new url, :GET, opts, block
  end

  def initialize(url, method, options, handler)
    @url    = url
    @method = method
    @ok     = true

    http = self

    %x{
      $.ajax({
        url: url,
        type: method,
        success:  function(str) {
          http.body = str;
          return #{ handler.call `http` };
        },
        error: function(xhr, str) {
          // result
          http.ok = false;
          return #{ handler.call `http` };
        }
      });
    }
  end

  # Parses the http response body through json. If the response is not
  # valid JSON then an error will very likely be thrown.
  #
  # @example
  #   # Getting JSON content
  #   HTTP.get("api.json") do |response|
  #     puts response.json
  #   end
  #
  #   # => {"key" => 1, "bar" => 2, ... }
  #
  # @return [Object] returns the parsed json
  def json
    JSON.parse @body
  end

  # Returns true if the request succeeded, false otherwise.
  #
  # @example
  #   HTTP.get("/some/url") do |response|
  #     if response.ok?
  #       alert "Yay!"
  #     else
  #       alert "Aww :("
  #     end
  #
  # @return [Boolean] true if request was successful
  def ok?
    @ok
  end
end