module RQuery
  class Document < Element

    def to_s
      "<document>"
    end

    def title
      `return document.title;`
    end

    def title=(str)
      `return document.title = str;`
    end

    def body
      @body ||= Element.from_native `document.getElementsByTagName('body')[0]`
    end

    def head
      @head ||= Element.from_native `document.getElementsByTagName('head')[0]`
    end

    def scripts
      raise "Should return ElementSet of elements"
    end

    def self.new(*a)
      raise "Not allowed to instantiate new document"
    end
  end
end

