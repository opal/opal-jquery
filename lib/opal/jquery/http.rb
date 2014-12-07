require 'json'
require 'native'
require 'promise'
require 'opal/jquery/constants'

# {HTTP} is used to perform a `XMLHttpRequest` in ruby. It is a simple wrapper
# around jQuerys' `$.ajax` call. `XMLHttpRequest` is not wrapped directly as
# jquery provides some cross browser fixes.
#
# # Making requests
#
# To create a simple request, {HTTP} exposes class level methods to specify
# the HTTP action you wish to perform. Each action accepts the url for the
# request, as well as optional arguments passed as a hash:
#
#     HTTP.get("/users/1.json")
#     HTTP.post("/users", payload: data)
#
# The supported `HTTP` actions are:
#
# * {HTTP.get}
# * {HTTP.post}
# * {HTTP.put}
# * {HTTP.delete}
# * {HTTP.patch}
# * {HTTP.head}
#
# # Handling responses
#
# Responses can be handled using either a simple block callback, or using a
# {Promise} returned by the request.
#
# ## Using a block
#
# All HTTP action methods accept a block which can be used as a simple
# handler for the request. The block will be called for both successful as well
# as unsuccessful requests.
#
#     HTTP.get("/users/1") do |request|
#       puts "the request has completed!"
#     end
#
# This `request` object will simply be the instance of the {HTTP} class which
# wraps the native `XMLHttpRequest`. {HTTP#ok?} can be used to quickly determine
# if the request was successful.
#
#     HTTP.get("/users/1") do |request|
#       if request.ok?
#         puts "request was success"
#       else
#         puts "something went wrong with request"
#       end
#     end
#
# The {HTTP} instance will always be the only object passed to the block.
#
# ## Using a Promise
#
# If no block is given to one of the action methods, then a {Promise} is
# returned instead. See the standard library for more information on Promises.
#
#     HTTP.get("/users/1").then do |req|
#       puts "response ok!"
#     end.fail do |req|
#       puts "response was not ok"
#     end
#
# When using a {Promise}, both success and failure handlers will be passed the
# {HTTP} instance.
#
# # Accessing Response Data
#
# All data returned from an HTTP request can be accessed via the {HTTP} object
# passed into the block or promise handlers.
#
# - {#ok?} - returns `true` or `false`, if request was a success (or not).
# - {#body} - returns the raw text response of the request
# - {#status_code} - returns the raw {HTTP} status code as integer
# - {#json} - tries to convert the body response into a JSON object
class HTTP
  `var $ = #{JQUERY_SELECTOR.to_n}` # cache $ for SPEED

  # All valid {HTTP} action methods this class accepts.
  #
  # @see HTTP.get
  # @see HTTP.post
  # @see HTTP.put
  # @see HTTP.delete
  # @see HTTP.patch
  # @see HTTP.head
  ACTIONS = %w[get post put delete patch head]

  # @!method self.get(url, options = {}, &block)
  #
  # Create a {HTTP} `get` request.
  #
  # @example
  #   HTTP.get("/foo") do |req|
  #     puts "got data: #{req.data}"
  #   end
  #
  # @param url [String] url for request
  # @param options [Hash] any request options
  # @yield [self] optional block to handle response
  # @return [Promise, nil] optionally returns a promise

  # @!method self.post(url, options = {}, &block)
  #
  # Create a {HTTP} `post` request. Post data can be supplied using the
  # `payload` options. Usually this will be a hash which will get serialized
  # into a native javascript object.
  #
  # @example
  #   HTTP.post("/bar", payload: data) do |req|
  #     puts "got response"
  #   end
  #
  # @param url [String] url for request
  # @param options [Hash] optional request options
  # @yield [self] optional block to yield for response
  # @return [Promise, nil] returns a {Promise} unless block given

  # @!method self.put(url, options = {}, &block)

  # @!method self.delete(url, options = {}, &block)

  # @!method self.patch(url, options = {}, &block)

  # @!method self.head(url, options = {}, &block)

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
  # @example Getting JSON content
  #   HTTP.get("api.json") do |response|
  #     puts response.json
  #   end
  #
  #   # => {"key" => 1, "bar" => 2, ... }
  #
  # @return [Hash, Array] returns the parsed json
  def json
    @json ||= JSON.parse(@body)
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
  # @return [true, false] true if request was successful
  def ok?
    @ok
  end

  # Returns the value of the specified response header.
  #
  # @param key [String] name of the header to get
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
