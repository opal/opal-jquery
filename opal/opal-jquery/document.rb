require 'opal-jquery/element'

$document = Element.find(`document`)

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

  def title
    `document.title`
  end

  def title=(title)
    `document.title = title`
  end
end

# Document is depreceated, use $document instead.
Document = $document

