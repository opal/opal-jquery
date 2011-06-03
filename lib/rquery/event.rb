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

