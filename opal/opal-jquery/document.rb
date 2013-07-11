require 'opal-jquery/element'

Document = Element.find(`document`)

class << Document
  def ready?(&block)
    `$(#{ block })` if block
  end

  def title
    `document.title`
  end

  def title=(title)
    `document.title = #{title}`
  end
end

# TODO: this will be removed soon (here for compatibility)
$document = Document
