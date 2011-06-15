module RQuery
  module CSS

  # Adds the given class or classes to each element in the receiver. Multiple
  # classes may be added by seperating them with a space. These classes do not
  # replace any previously set classes, but are instead added.
  #
  # @example HTML
  #
  #     !!!plain
  #     <ul>
  #       <li>First</li>
  #       <li>Second</li>
  #       <li>Third</li>
  #     </ul>
  #
  # @example Ruby
  #
  #     RQuery['li:last'].add_class 'selected'
  #
  # @example Result
  #
  #     !!!plain
  #     <ul>
  #       <li>First</li>
  #       <li>Second</li>
  #       <li class="selected">Third</li>
  #     </ul>
  #
  # @param [String] name the class(es) name(s)
  # @return [RQuery] returns the receiver
  def add_class(name)
    `var i, ii, el;

    for (i = 0, ii = self.length; i < ii; i++) {
      el = self[i].$elem;

      if ((' ' + el.className + ' ').indexOf(' ' + name + ' ') == -1) {
        el.className = (el.className + ' ' + name).replace(/\s+/g, ' ').replace(/^\s+|\s+$/g, '');
      }
    }`
    self
  end

  # Removes the given class or classes to each element in the receiver. Multiple
  # classes may be removed at once by passing in a space seperated string of
  # classnames. To remove all classes, don't pass in a parameter, which will
  # remove all set classes.
  #
  # @example HTML
  #
  #     !!!plain
  #     <p class="foo bar">First paragraph</p>
  #     <p class="foo bar">Second paragraph</p>
  #
  # @example Ruby
  #
  #     RQuery['p:first'].remove_class 'foo'
  #     RQuery['p:last'].remove_class
  #
  # @example Result
  #
  #     !!!plain
  #     <p class="bar">First paragraph</p>
  #     <p>Second paragraph</p>
  #
  # @param [String] name the classes to remove
  # @return [RQuery] returns the receiver
  def remove_class(name)
    `var i, ii, el;

    for (i = 0, ii = self.length; i < ii; i++) {
      el = self[i].$elem;
      el.className = (' ' + el.className + ' ').replace(' ' + name + ' ', ' ').replace(/\s+/g, ' ').replace(/^\s+|\s+$/g, '');
    }`
    self
  end

  def has_class?(name)
    `var i, ii, el;

    for (i = 0, ii = self.length; i < ii; i++) {
      el = self[i].$elem;

      if ((' ' + el.className + ' ').indexOf(' ' + name + ' ') != -1) {
        return #{ true };
      }
    }`
    false
  end

end
end

