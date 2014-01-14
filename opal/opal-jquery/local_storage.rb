module DOM
  class LocalStorage
    def initialize(storage)
      @storage = storage
    end

    def []=(key, value)
      `#@storage.setItem(key, value)`
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

LocalStorage = DOM::LocalStorage.new(`window.localStorage`)
