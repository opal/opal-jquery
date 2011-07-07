class RQuery
  # @group Attributes

  # Adds the given class `name` to each element in the receiver. Multiple
  # classes can be added by separating their names with a space. This will
  # not overwrite the current classes, but instead appends the given class
  # names to the existing classname attribute.
  #
  # @param [String] name The class name(s) to add
  # @return [self]
  def add_class(name)
    `self.addClass(name);`
    self
  end

  # Returns `true` if the given class `name` is present in any of the
  # elements in the receiver. `false` otherwise. This method will still
  # return `true` even if the matching element has other classes also
  # assigned to it.
  #
  # @param [String] name The class name to check
  # @return [true, false]
  def has_class?(name)
    `return self.hasClass(name) ? Qtrue : Qfalse;`
  end

  # Removes the given class `name` from each of the elements in the
  # receiver. Multiple classes can be removed at once by separating
  # each class with a space.
  #
  # @param [String] name The class name(s) to remove
  # @return [self]
  def remove_class(name)
    `self.removeClass(name);`
    self
  end

  # Goes through each element in the receiver and adds the given class
  # if it does not already have it, or removes it otherwise. Multiple
  # classes may be passed in and each checked individually against each
  # element in the receiver.
  #
  # @param [String] name The class name(s) to add/remove
  # @return [self]
  def toggle_class(name)
    `self.toggleClass(name);`
    self
  end

  # Gets the attribute value for `name` from the first element in the
  # receiver. Only the first element will be checked for attributes and
  # if the receiver is empty then `nil` will be returned. To retrieve
  # attributes for each element in the receiver, either select an
  # element directly, or loop over the receiver with {#each}.
  #
  # @param [String] name Attr name
  # @param [String] val optional attribute value to set
  # @return
  def [](name)
    `var res = self.attr(name);
    return res == undefined ? nil : res;`
  end

  def []=(name, val)
    `return self.attr(name, val);`
  end

  %w[src id href].each do |a|
    define_method(a) {
      `var res = self.attr(a); return res == undefined ? nil : res;`
    }
    define_method("#{a}=") { |val| `return self.attr(a, val);` }
  end

  # @endgroup
end

