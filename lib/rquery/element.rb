# Wraps native jQuery object and can therefore hold one or more real
# elements. This does NOT subclass Array, but does include the
# Enumerable module for convenience and it does implement many of the
# Array methods. This does not subclass array because the internal
# structure is a lot more complex as each individal element must be
# converted into a jquery instance on reference.
class Element
  # include Enumerable

  native_prototype `$.fn`

  # Returns the number of elements in the collection.
  #
  # @return [Numeric]
  def size
    `return self.length;`
  end

  alias_method :length, :size


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
  def attr(name, val = nil)
    `if (val == nil) {
      var res = self.attr(name);
      return res == undefined ? nil : res;
    } else {
      return self.attr(name, val);
    }`
  end

  ['src', 'id', 'href'].each do |a|
    define_method(a) {
      `var res = self.attr(a); return res == undefined ? nil : res;`
    }
    define_method("#{a}=") { |val| `return self.attr(a, val);` }
  end

  def id
    `return self.attr('id');`
  end

  # @endgroup

  # @group Traversing

  # Calls the given block once for each element in the receiver where the
  # given element is passed to the block. Each element is an instance of
  # the `Element` class and is the only item in the collection. Currently,
  # if no block is given then an exception is raised.
  #
  # @return [self]
  def each
    raise "no block given" unless block_given?

    `for (var i = 0, length = self.length; i < length; i++) {`
      yield `$(self[i])`
    `}`

    self
  end

  # Returns a new instance containing only those items for which the given
  # block evaluates to a true value. Each element in the receiver is passed
  # into the block in turn. This returns a new instance and does not
  # alter the receiver.
  #
  # @return [Element]
  def select
    raise "no block given" unless block_given?

    `var result = $(), arg;

    for (var i = 0, ii = self.length; i < ii; i++) {
      arg = self[i];

      if (#{yield `$(self[i])`}.$r) {
        result[result.length++] = arg;
      }
    }

    return result;`
  end

  # Returns a new instance with all elements for which the block is not
  # true. This does not affect the receiver as a new instance is returned.
  #
  # @return [Element]
  def reject
    raise "no block given" unless block_given?

    `var result = $(), arg;

    for (var i = 0, ii = self.length; i < ii; i++) {
      arg = self[i];

      if (!#{yield `$(self[i])`}.$r) {
        result[result.length++] = arg;
      }
    }

    return result;`
  end

  # @endgroup

  # @group Events

  [:click, :mousedown, :mouseup].each do |evt|
    name = evt.to_s
    define_method(evt) do |&block|
      `var func = function(evt) {
        return #{block.call evt} == Qfalse ? false : true;
      };

      self[name](func);`
      self
    end
  end

  # @endgroup
end

