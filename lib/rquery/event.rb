class RQuery

  class Event

    class EventInitializedError < Exception; end

    KEY_CODES = {
      8   => :backspace,
      9   => :tab,
      13  => :return,
      27  => :escape,
      32  => :space,
      37  => :left,
      38  => :up,
      39  => :right,
      40  => :down,
      46  => :delete
    }

    # Create an instance from a native js event
    def self.from_native(evt)
      `var res = #{ allocate };
      res.$evt = evt;
      return res;`
    end

    def initialize
      raise EventInitializedError, "Events cannot be manually created"
    end

    def stop
      prevent_defaut
      stop_propagation
    end

    def prevent_default
      `var evt = self.$evt;
      self.$default_prevented = true;
      evt.preventDefault ? evt.preventDefault() : evt.returnValue = false;`
      self
    end

    def default_prevented?
      `return self.$default_prevented ? Qtrue : Qfalse;`
    end

    def stop_propagation
      `var evt = self.$evt;
      self.$propagation_stopped = true;
      evt.stopPropagation ? evt.stopPropagation() : evt.cancelBubble = true;`
      self
    end

    def propagation_stopped?
      `return self.$propagation_stopped ? Qtrue : Qfalse;`
    end

    def target
      return @target if @target

      `var target = self.$evt.target;
      if (!target) { target = self.$et.srcElement || document; }`

      @target = RQuery.from_native `target`
    end

    def alt?
      `return self.$evt.altKey ? Qtrue : Qfalse;`
    end

    def ctrl?
      `return self.$evt.ctrlKey ? Qtrue : Qfalse;`
    end

    def shift?
      `return self.$evt.shiftKey ? Qtrue : Qfalse;`
    end

    def meta?
      `return self.$evt.metaKey ? Qtrue : Qfalse;`
    end

    def key
      return @key if @key

      `var code = self.$evt.which || self.$evt.keyCode;`
      key = KEY_CODES[`code`] || `$runtime.Y(String.fromCharCode(code))`
      @key = key
    end
  end # Event
end

# module RQuery

#   class Event

#     # Returns the actual element that initiated the event.
#     #
#     # @return [Element]
#     def target
#       `return $(self.target);`
#     end
#     # Returns the current target for the event.
#     #
#     def current
#       `return $(self.currentTarget);`
#     end

#     # The type of event that occured.
#     #
#     # FIXME: for now, these are the raw javascript/jquery names for the events
#     # and are not snake_cased. This needs to be fixed.
#     def type
#       `return self.type;`
#     end

#     # If {#prevent_default} has been called on the event, returns `true`, 
#     # otherwise returns `false`. 
#     #
#     # @example
#     #
#     #     Element['div'].mouse_down do |event|
#     #       event.default_prevented?      # => false
#     #       event.prevent_default
#     #       event.default_prevented?      # => true
#     #     end
#     #
#     # @return [true, false]
#     def default_prevented?
#       `return self.isDefaultPrevented() ? Qtrue : Qfalse;`
#     end

#     # Use this method to stop the default action of the event. For example, this 
#     # can be used to stop browsers following a href links on a page.
#     #
#     # @return [Event] returns the receiver
#     def prevent_default
#       `self.preventDefault()`
#       self
#     end

#     # Returns `true` if the alt key was pressed during the event, `false` 
#     # otherwise.
#     #
#     # @return [true, false]
#     def alt?
#       `return self.altKey ? Qtrue : Qfalse;`
#     end

#     # Returns `true` if the ctrl key was pressed during the event, `false`
#     # otherwise.
#     #
#     # @return [true, false]
#     def ctrl?
#       `return self.ctrlKey ? Qtrue : Qfalse;`
#     end

#     # Returns `true` if the shift key was pressed during the event, `false`
#     # otherwise.
#     #
#     # @return [true, false]
#     def shift?
#       `return self.shiftKey ? Qtrue : Qfalse;`
#     end

#     # Returns `true` if the meta key was pressed during the event, `false`
#     # otherwise.
#     #
#     # @return [true, false]
#     def meta?
#       `return self.metaKey ? Qtrue : Qfalse;`
#     end

#     # Stops the event from propagating up the DOM tree so that parent elements
#     # will not receive the event.
#     #
#     # @return [Event] returns the receiver.
#     def stop_propagation
#       `self.stopPropagation()`
#       self
#     end

#     # Returns `true` if {#stop_propagation} was called on the receiver, `false`
#     # otherwise.
#     #
#     # @example
#     #
#     #     Element['div'].mouse_down do |evt|
#     #       evt.propagation_stopped?      # => false
#     #       evt.stop_propagation
#     #       evt.propagation_stopped?      # => true
#     #     end
#     #
#     # @return [true, false]
#     def propagation_stopped?
#       `return self.isPropagationStopped() ? Qtrue : Qfalse;`
#     end
#   end
# end

