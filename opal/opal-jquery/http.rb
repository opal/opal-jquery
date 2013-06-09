# Wraps jQuery's ajax request into a ruby class.
#
#     HTTP.get("/users/1.json") do |response|
#       puts "Got response!"
#     end
#
class HTTP
  attr_reader :body, :error_message, :method, :status_code, :url, :xhr

  def self.get(url, opts={}, &block)
    self.new(url, :GET, opts, block).send!
  end

  def self.post(url, opts={}, &block)
    self.new(url, :POST, opts, block).send!
  end

  def self.put(url, opts={}, &block)
    self.new(url, :PUT, opts, block).send!
  end

  def self.delete(url, opts={}, &block)
    self.new(url, :DELETE, opts, block).send!
  end

  def initialize(url, method, options, handler=nil)
    @url     = url
    @method  = method
    @ok      = true
    @xhr     = nil
    http     = self
    payload  = options.delete :payload
    settings = options.to_n

    if handler
      @callback = @errback = handler
    end

    %x{
      if (typeof(payload) === 'string') {
        settings.data = payload;
      }
      else if (payload != null) {
        settings.data = payload.$to_json();
        settings.contentType = 'application/json';
      }

      settings.url  = url;
      settings.type = method;

      settings.success = function(data, status, xhr) {
        http.body = data;
        http.xhr = xhr;

        if (typeof(data) === 'object') {
          http.json = #{ JSON.from_object `data` };
        }

        return #{ http.succeed };
      };

      settings.error = function(xhr, status, error) {
        http.body = xhr.responseText;
        http.xhr = xhr;

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

  # Returns the value of the specified response header.
  #
  # @param [String] name of the header to get
  # @return [String] value of the header
  def get_header(key)
    `#{xhr}.getResponseHeader(#{key});`
  end
end
