require 'json'
require 'native'
require 'promise'
require 'opal-jquery/constants'

class HTTP
  `var $ = #{JQUERY_SELECTOR.to_n}` # cache $ for SPEED

  ACTIONS = %w[get post put delete patch head]

  ACTIONS.each do |action|
    define_singleton_method(action) do |url, options = {}, &block|
      new.send(action, url, options, block)
    end

    define_method(action) do |url, options = {}, &block|
      send(action, url, options, block)
    end
  end

  def self.setup
    Hash.new(`$.ajaxSetup()`)
  end

  def self.setup= settings
    `$.ajaxSetup(#{settings.to_n})`
  end

  attr_reader :body, :error_message, :method, :status_code, :url, :xhr

  def initialize
    @settings = {}
    @ok = true
  end

  def send(method, url, options, block)
    @method   = method
    @url      = url
    @payload  = options.delete :payload
    @handler  = block

    @settings.update options

    settings, payload = @settings.to_n, @payload

    %x{
      if (typeof(#{payload}) === 'string') {
        #{settings}.data = payload;
      }
      else if (payload != nil) {
        settings.data = payload.$to_json();
        settings.contentType = 'application/json';
      }

      settings.url  = #@url;
      settings.type = #{@method.upcase};

      settings.success = function(data, status, xhr) {
        return #{ succeed `data`, `status`, `xhr` };
      };

      settings.error = function(xhr, status, error) {
        return #{ fail `xhr`, `status`, `error` };
      };

      $.ajax(settings);
    }

    @handler ? self : promise
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

  # Returns the value of the specified response header.
  #
  # @param [String] name of the header to get
  # @return [String] value of the header
  def get_header(key)
    `#@xhr.getResponseHeader(#{key});`
  end

  private

  def promise
    return @promise if @promise

    @promise = Promise.new.tap { |promise|
      @handler = proc { |res|
        if res.ok?
          promise.resolve res
        else
          promise.reject res
        end
      }
    }
  end

  def succeed(data, status, xhr)
    %x{
      #@body = data;
      #@xhr  = xhr;
      #@status_code = xhr.status;

      if (typeof(data) === 'object') {
        #@json = #{ JSON.from_object `data` };
      }
    }

    @handler.call self if @handler
  end

  def fail(xhr, status, error)
    %x{
      #@body = xhr.responseText;
      #@xhr = xhr;
      #@status_code = xhr.status;
    }

    @ok = false
    @handler.call self if @handler
  end
end
