require 'opal-jquery/element'

Window = Element.find `window`

class << Window
  # Code extracted from http://andylangton.co.uk/blog/development/get-viewport-size-width-and-height-javascript
  def width
    `window.innerWidth || (document.documentElement || document.body).clientWidth`
  end

  def height
    `window.innerHeight || (document.documentElement || document.body).clientHeight`
  end
end

$window = Window