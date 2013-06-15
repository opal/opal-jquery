require 'opal-jquery/element'

$document = Element.find($global.document)

class << $document
  # Use Element.ready? instead
  def ready?(&block)
    Element.ready?(&block)
  end
end

# TODO: this will be removed soon (here for compatibility)
Document = $document
