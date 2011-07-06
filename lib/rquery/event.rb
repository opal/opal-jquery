class Event

  native_prototype `$.Event.prototype`

  # Exception raised when an event is created manually. Events should
  # not be created manually and instead originate from jQuery.
  class NewEventError < Exception; end

  # Events in RQuery are always created from external sources, namely
  # jquery's event system. It is never required for events to be
  # manually created, so the allocation function just yields an error
  # if called.
  def self.allocate
    raise EventInitializedError, "Events cannot be manually created"
  end

  # Returns the actual element that triggered the event, wrapped in
  # an `Element`. The target may not be the element that is being
  # observed for events, but it could be one of its descendants and
  # the event is bubbling up through the DOM.
  #
  # @return [Element]
  def target
    `return $(self.target);`
  end

  # Returns the type of event as a symbol.
  #
  # @return [Symbol]
  def type
    `return $rb.Y(self.type);`
  end

  # Returns the mouse position that the event occured at. This is
  # relative to the left of the page.
  #
  # @return [Numeric]
  def page_x
    `return self.pageX;`
  end

  # Returns the mouse position of the event relative to the top of the
  # page.
  #
  # @return [Numeric]
  def page_y
    `return self.pageY;`
  end

  # Left mouse position relative to the viewport
  #
  # @return [Numeric]
  def client_x
    `return self.clientX;`
  end

  # Top mouse position relative to the viewport.
  #
  # @return [Numeric]
  def client_y
    `return self.clientY;`
  end

  def stop
    prevent_defaut
    stop_propagation
  end

end # Event

