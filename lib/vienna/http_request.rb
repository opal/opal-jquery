module Vienna

  class HttpRequest

    attr_reader :response

    def initialize(url)
      @url = url
      @completed = false
      @response = ''
      `self.$xhr = new XMLHttpRequest();`
      self
    end

    def get(options = {})
      self
    end

    def post(options = {})
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

    def __send_request__(method, options)
      method = method.to_s

      `var xhr = self.$xhr, url = #{ @url };

      xhr.open(method.toUpperCase(), url, true);

      xhr.onreadystatechange = function() {
        if (xhr.readyState == 4) {
          xhr.onreadystatechange = null;

          #{ @response = `(xhr.responseText || '')` };
        }
      };

      xhr.send(null);


      return self;`
    end
  end # HttpRequest
end

