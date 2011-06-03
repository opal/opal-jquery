# module RQuery

#   # Instances of Response are automatically created by Request, so you do
#   # not need to make them yourself. This is the object that will be passed
#   # to each of the callbacks for a Request object. For this reason, this
#   # object will be created if the request succeeds, or indeed fails.
#   class Response
#     # Private initializer. This handles a native jquery requets object, so
#     # this should all probably be private.
#     def initialize(request)
#       `self.$xhr = request`
#     end

#     # Returns the numeric status code for the response.
#     #
#     # @return [Numeric]
#     def status
#       `return self.$xhr.status;`
#     end

#     # Returns the string status message for the response.
#     #
#     # @return [String]
#     def status_text
#       `return self.$xhr.statusText;`
#     end

#     # Returns the response text from the request.
#     #
#     # @return [String]
#     def text
#       `return self.$xhr.responseText;`
#     end

#     # Returns `true` if the response represents a successfull request,
#     # `false` otherwise.
#     #
#     # @return [true, false]
#     def success?
#       `return (self.$xhr.status >= 200 && self.$xhr.status < 300) ? Qtrue : Qfalse;`
#     end

#     # Returns `false` if the response was the result of an unsuccessful
#     # request, `true` otherwise.
#     #
#     # @return [true, false]
#     def failure?
#       !success?
#     end
#   end
# end

