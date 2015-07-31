require 'native'

unless defined?(JQUERY_CLASS)
  case
  when `!!Opal.global.jQuery`
    JQUERY_CLASS = JQUERY_SELECTOR = `Opal.global.jQuery`
  when `!!Opal.global.Zepto`
    JQUERY_SELECTOR = `Opal.global.Zepto`
    JQUERY_CLASS = `Opal.global.Zepto.zepto.Z`
  else
    raise NameError, "Can't find jQuery or Zepto. jQuery must be included before opal-jquery"
  end
end
