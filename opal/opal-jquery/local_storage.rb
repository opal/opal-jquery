module Browser
  # {Browser::LocalStorage} is a simple wrapper around `localStorage` in the
  # browser.
  #
  # Instead of using the class directly, the main instance {LocalStorage}
  # should be used instead. This class can be used to wrap an instance from
  # another window or iframe if required.
  #
  # ## Usage
  #
  #     LocalStorage['foo'] = 'hello world'
  #
  #     LocalStorage['foo'] # => "hello world"
  #     LocalStorage['bar'] # => nil
  #
  # @see LocalStorage
  class LocalStorage
    def initialize(storage)
      @storage = storage
    end

    def []=(key, value)
      %x{
        #@storage.setItem(key, value);
        return value;
      }
    end

    def [](key)
      %x{
        var value = #@storage.getItem(key);
        return value == null ? nil : value;
      }
    end

    def delete(key)
      `#@storage.removeItem(key)`
    end

    def clear
      `#@storage.clear()`
    end
  end
end

# {LocalStorage} is the top level instance of {Browser::LocalStorage} that
# wraps `window.localStorage`, aka the `localStorage` object available on
# the main window.
LocalStorage = Browser::LocalStorage.new(`window.localStorage`)
