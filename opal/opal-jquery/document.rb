require 'opal-jquery/constants'
require 'opal-jquery/element'

Document = Element.find(`document`)

class << Document
  `var $ = #{JQUERY_SELECTOR.to_n}` # cache $ for SPEED

  def ready?(&block)
    `$(#{ block })` if block
  end

  def title
    `document.title`
  end

  def title=(title)
    `document.title = #{title}`
  end

  def head
    Element.find(`document.head`)
  end

  def body
    Element.find(`document.body`)
  end
end

# TODO: this will be removed soon (here for compatibility)
$document = Document
