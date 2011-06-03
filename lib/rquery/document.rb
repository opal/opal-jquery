require 'rquery/element'

class RQuery < Array

  module DocumentMethods

    def to_s
      "#<RQuery document>"
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

  @document = from_native `document`
  class << @document; include DocumentMethods; end

  def self.document
    @document
  end
end


