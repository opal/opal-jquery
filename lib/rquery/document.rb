require 'rquery/element'

module RQuery

  module DocumentMethods

    def to_s
      "<document>"
    end

    alias_method :inspect, :to_s

    def title
      `return document.title;`
    end

    def title=(str)
      `return document.title = str;`
    end

    def body
      @body ||= self.class.from_native(`document.getElementsByTagName('head')[0]`)
    end

    # def head; end
  end

  def self.document
    return @document if @document

    `var doc = #{Element.allocate};
    doc.$elem = document;
    doc.length = 1;
    doc[0] = doc;`

    @document = `doc`
  end

  class << document; include RQuery::DocumentMethods; end
end

