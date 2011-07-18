class RQuery
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

  # Returns the first `count` number of elements from the receiver, or
  # just the first if count is not given. If a count is given and this
  # collection is empty, then an empty RQuery instance is returned. If
  # no count is given to an empty collection then `nil` is returned.
  #
  # @param [Numeric] count The number of elements to return
  # @return [RQuery, nil] Returns new RQuery instance
  def first(count = nil)
    `if (count == nil) {
      if (self.length == 0) return nil;
      return $(self[0]);
    }
    return self.slice(0, count);`
  end

  # Returns a new instance with the last element in the receiver, or the
  # last `count` elements if a count is given. If there are no elements
  # and no count is given, then `nil` is returned.
  #
  # @param [Numeric] count The number of elements to return
  # @param [RQuery, nil] Returns new RQuery instance
  def last(count = nil)
    `if (count == nil) {
      if (self.length == 0) return nil;
      return $(self[self.length - 1]);
    } else {
      if (count > self.length) count = self.length;
      return self.slice(self.length - count, self.length);
    }`
  end

  # Returns a new RQuery instance that contains all of the children
  # belonging to the elements in this collection. This will only
  # search for element nodes and will not return any text nodes.
  #
  # @return [RQuery]
  def children
    `return self.children();`
  end

  # Return a new instance which contains descendants of the elements
  # in this collection that match the given selector.
  #
  # @param [String] selector Selector string to match
  # @return [RQuery]
  def find(selector)
    `return self.find(selector);`
  end

  # @endgroup
end

