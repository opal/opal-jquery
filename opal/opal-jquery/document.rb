require 'opal-jquery/element'

$document = Element.find($global.document)

class << $document
  def ready?(&block)
    `$(#{ block })` if block
  end
end

# TODO: this will be removed soon (here for compatibility)
Document = $document
