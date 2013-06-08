require 'opal-jquery/element'

class Element

  # Returns a jquery wrapped version of document
  def self.document
    @_doc ||= Element.find(`document`)
  end
end

Document = Element.document

def Document.ready?(&block)
  %x{
    if (block == nil) {
      return null;
    }

    $(block);
    return null;
  }
end

