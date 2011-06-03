# module RQuery

#   # The Request class wraps the native XMLHttpRequest object in the
#   # browser and makes use of jQuery's ajax facilities to make requests.
#   class Request

#     # Default options used by all Requests. Unless an option here is
#     # overrideen, then these defaults will be used on each request. This
#     # is not a full list of all options that can be used; these are just
#     # the bare essentials and useful defaults.
#     # DEFAULT_OPTIONS = {
#       # :url    => '',
#       # :type   => 'GET'
#     # }

#     # Creates a new Request object. The passed options are merged with
#     # DEFAULT_OPTIONS and will be used as the base options for each
#     # request. Request specific options may be passed to {#send}, and
#     # these will be used in preference to the options passed here.
#     #
#     # Most of the options that can be set also have their own designated
#     # getters and setters as instance methods on this class. This allows
#     # for options to be set in a more independant manner instead of
#     # collecting all options into the initialization hash.
#     #
#     # @param [Hash] options request options
#     # @return [Request] returns new request instance 
#     def initialize(options = {})
#       @options          = DEFAULT_OPTIONS.merge options
#       @complete_action  = nil
#       @failure_action   = nil
#       @success_action   = nil
#     end

#     # Creates attribute reader and writers for the given options that will
#     # set/retrieve the values from the options hash belonging to this
#     # instance. Each of these options may also be overriden by the final
#     # values sent to {#send}, or one of its aliases: {#get}, {#post},
#     # {#put} or {#delete}.
#     #
#     # @param [String, Symbol] names option names to set
#     def self.option_accessor(*names)
#       names.each do |name|
#         # define option getter
#         define_method(name) { @options[name] }
#         # define option setter
#         define_method("#{name}=") { |value| @options[name] = value }
#       end
#     end

#     # By default all requests will be sent async, to avoid locking up the
#     # browser. Set this to `false` to send requests in a sync fashion.
#     # This defaults to `true` to send by async by default.
#     option_accessor :async

#     # Gets the type of the request, which is "GET" by default. This value
#     # may be "GET" or "POST", as they are well supported by the browser,
#     # but "PUT" and "DELETE" may also be used, but they are not supported
#     # within the browser.
#     option_accessor :type

#     # Holds the string representing the URL to which the request is sent.
#     # By default this is an empty string, so it needs to be set to get any
#     # useful requests back.
#     option_accessor :url

#     # Sets the username to use when accessing the HTTP authentication
#     # requests.
#     option_accessor :username

#     # Sets the relevant password used in the HTTP authentication requests.
#     option_accessor :password

#     # Sends the request with the specified options. These options are
#     # merged with the options given to {#initialize}. There are also
#     # aliases for this method for automatically setting the request
#     # type; {#put}, {#post}, {#get} and {#delete} will automatically
#     # set the correct request type to avoid the need to set it in the
#     # options.
#     #
#     # @param [Hash] options the request options
#     # @return [Request] returns the receiver
#     def send(options = {})
#       `options = #{@options.merge options};

#       // native options object
#       var opts = {};

#       // we must have a url
#       opts.url = #{options[:url]}

#       // request type
#       opts.type = #{options[:type]}

#       // success callback
#       if (#{@success_action} != nil) {
#         opts.success = function(data, textStatus, jqXHR) {
#           var response = #{Response.new `jqXHR`};
#           #{@success_action.call `response`};
#         };
#       }

#       $.ajax(opts);

#       return self;`
#     end

#     def get(options = {})
#       options[:type] = 'GET'
#       send options
#     end

#     def post(options = {})
#       options[:type] = 'POST'
#       send options
#     end

#     def put(options = {})
#       options[:type] = 'PUT'
#       send options
#     end

#     def delete(options = {})
#       options[:type] = 'DELETE'
#       send options
#     end

#     # Register a block that will be called if the request succeeds. 
#     def success(&block)
#       @success_action = block
#     end

#     # Register a block that will be called if the request fails
#     def failure(&block)
#       @failure_action = block
#     end
#   end
# end

