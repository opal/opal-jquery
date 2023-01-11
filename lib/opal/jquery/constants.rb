require 'native'

unless defined?(JQUERY_CLASS)
  if `!!Opal.global.jQuery`
    JQUERY_CLASS = JQUERY_SELECTOR = `Opal.global.jQuery`
  else
    raise NameError, "Can't find jQuery. jQuery must be included before opal-jquery."
  end
end
