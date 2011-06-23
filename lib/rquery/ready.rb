module RQuery

  @ready = false
  @ready_blocks = []

  # Takes a block and yields it once the host document is ready. If this is
  # called post document load then the block will be called instantly. If no
  # block is given then this method simply returns `true` or `false`
  # depending on whether the document has already loaded.
  #
  # @return [true, false]
  def self.ready?(&blk)
    if block_given?
      if @ready
        yield
      else
        @ready_blocks << blk
      end
    end
    @ready
  end

  def self.__handle_ready__
    return unless @ready
    blocks = @ready_blocks

    block.call while block = blocks.pop
  end

  `(function() {
    var ready_function;

    if (document.addEventListener) {
      document.addEventListener("DOMContentLoaded", ready_function, false);

      ready_function = function() {
        document.removeEventListener("DOMContentLoaded", ready_function, false);
        #{ @ready = true };
        #{ __handle_ready__ };
      };
    }
    else {
      window.attachEvent("onload", ready_function);
    }

    if (document.readyState == "complete") {
      setTimeout(ready_function, 0);
    }

  })();`
end

