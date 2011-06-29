require 'rquery/event'

module Event::DomEvents

  EVENTS = [
    :click, :mouse_up, :mouse_down,
    :key_down, :key_press, :key_up
  ]

  EVENTS.each do |evt|
    define_method(evt) do |&block|
      listen(evt, &block)
    end
  end

  # Adds the block as a listener for the given event `event`. The
  # event may be a string or symbol and be either a rubyish name,
  # e.g. "mouse_down" or a native javascriptish name, e.g.
  # "mousedown".
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
  #     Document[:foo].on(:mouse_down) do |e|
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
    `var native = event.replace('_', '');
    var el = self.$el;

    var func = function(evt) {
      var e = #{ Event.from_native `evt` };
      #{ block.call `e` };
      return true;
    };

    block.$rquery_handler = func;

    if (el.addEventListener) {
      el.addEventListener(native, func, false);
    } else {
      el.attachEvent('on' + native, func);
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
    `var native = event.replace('_', '');
    var handler = block.$rquery_handler, el = self.$el;

    if (!handler) {
      #{ raise "block is not an event handler" };
    }

    if (el.addEventListener) {
      el.removeEventListener(native, handler, false);
    } else {
      el.detachEvent('on' + native, handler);
    }`
    block
  end
end

