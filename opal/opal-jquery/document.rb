require 'opal-jquery/element'

$document = Element.find($global.document)

class << $document
  def ready?(&block)
    `$(#{ block })` if block
  end
end
