require 'native'

unless defined?(JQUERY_CLASS)
  case
  when $$[:jQuery]
    JQUERY_CLASS = JQUERY_SELECTOR = $$[:jQuery]
  when $$[:Zepto]  then
    JQUERY_SELECTOR = $$[:Zepto]
    JQUERY_CLASS = $$[:Zepto][:zepto][:Z]
  else
    raise NameError, 'Can\'t find jQuery or Zepto. jQuery must be included before opal-jquery'
  end
end
