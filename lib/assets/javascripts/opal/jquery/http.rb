# Wraps jQuery's ajax request into a ruby class.
#
#     HTTP.get("/users/1.json") do |response|
#       puts "Got response!"
#     end
#
class HTTP
  attr_reader :body
  attr_reader :error_message
  attr_reader :method
  attr_reader :status_code
  attr_reader :url

  def self.get(url, opts={}, &block)
    self.new(url, :GET, opts, block).send!
  end

  def self.post(url, opts={}, &block)
    self.new(url, :POST, opts, block).send!
  end

  def self.put(url, opts={}, &block)
    self.new(url, :PUT, opts, block).send!
  end

  def initialize(url, method, options, handler=nil)
    @url     = url
    @method  = method
    @ok      = true
    http     = self
    payload  = options.delete :payload
    settings = options.to_native

    if handler
      @callback = @errback = handler
    end

    %x{
      if (typeof(payload) === 'string') {
        settings.data = payload;
      }
      else if (payload !== nil) {
        settings.data = payload.$to_json();
        settings.contentType = 'application/json';
      }

      settings.url  = url;
      settings.type = method;

      settings.success = function(str) {
        http.body = str;

        if (typeof(str) === 'object') {
          http.json = #{ JSON.from_object `str` };
        }

        return #{ http.succeed };
      };

      settings.error = function(xhr, str) {
        return #{ http.fail };
      };
    }

    @settings = settings
  end

  def callback(&block)
    @callback = block
    self
  end

  def errback(&block)
    @errback = block
    self
  end

  def fail
    @ok = false
    @errback.call self if @errback
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
    @json || JSON.parse(@body)
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

  # Actually send this request
  #
  # @return [HTTP] returns self
  def send!
    `$.ajax(#{ @settings })`
    self
  end

  def succeed
    @callback.call self if @callback
  end
end
