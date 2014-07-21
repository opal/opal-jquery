require 'json'
require 'native'
require 'promise'
require 'opal-jquery/constants'

class HTTP
  `var $ = #{JQUERY_SELECTOR.to_n}` # cache $ for SPEED

  def self.setup
    Hash.new(`$.ajaxSetup()`)
  end

  def self.setup= settings
    `$.ajaxSetup(#{settings.to_n})`
  end


  attr_reader :body, :error_message, :method, :status_code, :url, :xhr

  def self.get(url, opts={}, &block)
    build_request url, :GET, opts, block
  end

  def self.post(url, opts={}, &block)
    build_request url, :POST, opts, block
  end

  def self.put(url, opts={}, &block)
    build_request url, :PUT, opts, block
  end

  def self.delete(url, opts={}, &block)
    build_request url, :DELETE, opts, block
  end

  def self.patch(url, opts={}, &block)
    build_request url, :PATCH, opts, block
  end

  def self.head(url, opts={}, &block)
    build_request url, :HEAD, opts, block
  end

  def self.build_request(url, method, options, block)
    unless block
      promise = ::Promise.new
      block = proc do |response|
        if response.ok?
          promise.resolve response
        else
          promise.reject response
        end
      end
    end

    http = new(url, method, options, block).send!
    promise || http
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
      else if (payload != nil) {
        settings.data = payload.$to_json();
        settings.contentType = 'application/json';
      }

      settings.url  = url;
      settings.type = method;

      settings.success = function(data, status, xhr) {
        http.body = data;
        http.xhr = xhr;
        http.status_code = xhr.status;

        if (typeof(data) === 'object') {
          http.json = #{ JSON.from_object `data` };
        }

        return #{ http.succeed };
      };

      settings.error = function(xhr, status, error) {
        http.body = xhr.responseText;
        http.xhr = xhr;
        http.status_code = xhr.status;

        return #{ http.fail };
      };
    }

    @settings = settings
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
