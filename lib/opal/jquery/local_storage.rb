# backtick_javascript: true

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
  # LocalStorage is not included by default when you require opal-jquery, so
  # you will need to require it explicitly in your code:
  #
  #     require 'opal/jquery'
  #     require 'opal/jquery/local_storage'
  #
  #     puts LocalStorage
  #     # => #<LocalStorage>
  #
  # ## Example Usage
  #
  #     LocalStorage['foo'] = 'hello world'
  #
  #     LocalStorage['foo'] # => "hello world"
  #     LocalStorage['bar'] # => nil
  #
  # @see LocalStorage
  #
  class LocalStorage
    def initialize(storage)
      @storage = storage
    end

    # Set a value in storage.
    #
    # Values stored in {LocalStorage} will be stored as strings. To store any
    # other type of object, you will need to convert them to a string first,
    # and then convert them back from {#[]}. For this reason it is recommended
    # to only store {JSON} based objects in storage, so they can be easily
    # converted back and forth.
    #
    # @param key [String] string key
    # @param value [String, #to_s] string or explicitly converted object
    def []=(key, value)
      %x{
        #@storage.setItem(key, value);
        return value;
      }
    end

    # Retrieve an object from {LocalStorage}.
    #
    # Only string values can be stored, so any object will be returned as a
    # string. You will need to handle any conversion back into a normal
    # object. {JSON.parse} could be used, for example, to parse back into
    # arrays or hashes.
    #
    # If a key is not present in the storage, then `nil` will be returned.
    #
    # @param key [String] key to lookup
    # @return [String, nil]
    def [](key)
      %x{
        var value = #@storage.getItem(key);
        return value == null ? nil : value;
      }
    end

    # Removes a specific `key` from storage. If the key does not exist then
    # there is no side effect.
    #
    # @param key [String] key to remove
    def delete(key)
      `#@storage.removeItem(key)`
    end

    # Remove all key/values from storage
    def clear
      `#@storage.clear()`
    end
  end
end

# {LocalStorage} is the top level instance of {Browser::LocalStorage} that
# wraps `window.localStorage`, aka the `localStorage` object available on
# the main window.
LocalStorage = Browser::LocalStorage.new(`window.localStorage`)
