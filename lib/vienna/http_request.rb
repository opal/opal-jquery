require 'vienna/event_dispatcher'

module Vienna

  class HttpRequest
    include EventDispatcher

    dispatches :success
    dispatches :failure

    attr_reader :response

    # Ready states from native (XMLHttpRequest) to symbols. These are
    # used internally to report back the status of the request by some
    # dispatchable methods
    READY_STATES = {
      0   => :uninitialized,
      1   => :loading,
      2   => :loaded,
      3   => :interactive,
      4   => :complete
    }

    def initialize(url)
      @url = url
      @completed = false
      @response = ''
      `self.$xhr = new XMLHttpRequest();`
      self
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
        #{ dispatch(success? ? :success : :failure) };
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

