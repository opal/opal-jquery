require 'opal-jquery/element'

class Element

  # Returns a jquery wrapped version of document
  def self.document
    @_doc ||= Element.find(`document`)
  end
end

class << $document
  def ready?(&block)
    %x{
      if (block === nil) {
        return nil;
      }

      $(block);
      return nil;
    }
  end
end

# Document is depreceated, use Element.document instead
Document = Element.document

