require 'opal-jquery/element'

class Element

  # Returns a jquery wrapped version of document
  def self.document
    @_doc ||= Element.find(`document`)
  end
end

Document = Element.document

class << Document
  def self.ready?(&block)
    %x{
      if (block === nil) {
        return nil;
      }

      $(block);
      return nil;
    }
  end
end

