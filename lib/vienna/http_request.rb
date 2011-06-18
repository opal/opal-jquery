require 'vienna/event_dispatcher'

module Vienna

  class HttpRequest
    include EventDispatcher

    dispatch :wow_son

    attr_reader :response

    def initialize(url)
      @url = url
      @completed = false
      @response = ''
      `self.$xhr = new XMLHttpRequest();`
      self
    end

    # Returns self for chaining
    def success(&blk)
      if @completed
        # call anyway?
      else
        @success = blk
      end
      self
    end

    # Returns self for chaining
    def failure(&blk)
      if @completed
        # ...
      else
        @failure = blk
      end
      self
    end

    # Called on self when the request succeeds
    def succeed
      @success.call self if @success
    end

    # Called on self once the request fails/timeouts etc
    def fail
      @failure.call self if @failure
    end

    # Define standard http methods to send request
    [:get, :post].each do |method|
      define_method(method) do |options = {}|
        __send_request__ method, options
      end
    end

    def status
      `try {
        return self.$xhr.status || 0;
      } catch (e) {
        return 0;
      }`
    end

    def status_text
      `try {
        return self.$xhr.statusText || "";
      } catch (e) {
        return "";
      }`
    end

    def success?
      `var status = 0;

      try {
        status = self.$xhr.status || 0;
      } catch (e) {}

      if (status >= 200 && status < 300) { return Qtrue; }

      return (status == 0 && self.$xhr.responseText) ? Qtrue : Qfalse;`
    end

    def failure?
      !success?
    end

    alias_method :response_text, :response

    def state_changed
      `var xhr = self.$xhr;

      if (xhr.readyState == 4) {
        #{ @response = `xhr.responseText` };
        #{ success? ? succeed : fail };
      }`
      self
    end

    def __send_request__(method, options)
      method = method.to_s

      `var xhr = self.$xhr, url = #{ @url };

      xhr.open(method.toUpperCase(), url, true);

      xhr.onreadystatechange = function() {
        #{ state_changed };
      };

      xhr.send(null);

      return self;`
    end
  end # HttpRequest
end

