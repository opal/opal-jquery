class Element < Array

  module DOMEvents

    EVENT_MAP = {
      :click        => 'click',
      :mouse_down   => 'mousedown',
      :mouse_up     => 'mouseup'
    }

    EVENT_MAP.each do |method_id, native_id|
      define_method(method_id) do |&blk|
        if block_given?
          bind method_id, &blk
        else
          trigger method_id
        end
      end
    end

    # @param [Symbol] event Name of the event to bind to the receiver
    def bind(event, &action)
      type = EVENT_MAP[event]

      each do |elem|
        `var el = elem.$elem;

        var handle = function(event) {
          var evt = #{ Event.from_native `event` };
          return #{action.call `evt`};
        };

        if (el.addEventListener) {
          el.addEventListener(type, handle, false);
        } else {
          el.attachEvent('on' + type, handle);
        }`
      end

      self
    end

    # @param [Symbol] event The name of the dom event to trigger
    def trigger(event)

    end

  end # DOMEvents
end

