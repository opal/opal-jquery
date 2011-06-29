require 'rquery/event'

module Event::DomEvents

  EVENTS = [
    :click, :mouseup, :mousedown,
    :keydown, :keypress, :keyup
  ]

  EVENTS.each do |evt|
    define_method(evt) do |&block|
      listen(evt, &block)
    end
  end

  # Adds the block as a listener for the given event `event`. The
  # event may be a string or symbol.
  #
  # This method returns the passed in block so it can be saved for
  # later removing from the handler list.
  #
  # @example Handling a mouse down event
  #
  # Given the following HTML:
  #
  #     <div id="foo"></div>
  #
  # And the given Ruby code:
  #
  #     Document[:foo].on(:mousedown) do |e|
  #       puts "#{e} was clicked"
  #     end
  #
  # Clicking the div will result in:
  #
  #     # => "#<Element: div id="foo"> was clicked"
  #
  # @param [String, Symbol] event The event name to handle
  # @return [block]
  def listen(event, &block)
    raise "no block given" unless block_given?
    event = event.to_s
    `var el = self.$el;

    var func = function(evt) {
      var e = #{ Event.from_native `evt` };
      #{ block.call `e` };
      return true;
    };

    block.$rquery_handler = func;

    if (el.addEventListener) {
      el.addEventListener(event, func, false);
    } else {
      el.attachEvent('on' + event, func);
    }`
    block
  end

  # Removes the given listener from the set of event listeners
  # for this element. Currently, trying to remove a block that
  # is not a listener will be silently dropped.
  #
  # Also, the block here should be passed in as a regular
  # argument - it does not need to be passed in as a block.
  def unlisten(event, block)
    event = event.to_s
    `var handler = block.$rquery_handler, el = self.$el;

    if (!handler) {
      #{ raise "block is not an event handler" };
    }

    if (el.addEventListener) {
      el.removeEventListener(event, handler, false);
    } else {
      el.detachEvent('on' + event, handler);
    }`
    block
  end
end

