var define_method = VM.define_method,
    define_class  = VM.define_class;

/**
 * Adds properties to +element+ to make it act like a ruby element
 * instance.
 */
function wrap_element(elm) {
  elm.$m = Element.$m_tbl;
  elm.$k = Element;
  return elm;
}

/**
 * :call-seq:
 *    elm.collect(sym)    -> ary
 *
 * Returns an array of all elements relative to +self+. +prop+ should
 * be a native property name of the receiver element that points to a
 * relative element (e.g. `parentNode`).
 *
 *   elm.collect(:parentNode)
 *   # => [<body>, <html>]
 */
function collect(elm, prop) {
  var result = [];

  while (elm = elm[prop]) {
    if (elm.nodeType === 1) {
      result.push(wrap_element(elm));
    }
  }

  return result;
}

/**
 * :call-seq:
 *    elm.collect_one(sym)  -> elm
 *
 * Similar to +collect+, except collects only the first matching element,
 * or +nil+ if one does not exist.
 */
function collect_one(elm, prop) {
  while (elm = elm[prop]) {
    if (elm.nodeType === 1) {
      return wrap_element(elm);
    }
  }

  return null;
}

/**
 * :call-seq:
 *    elm.get_attribute(sym)    -> val
 *    elm.get_attribute(sym)   -> nil
 *
 * Defaults to w3c beahviour. Gets replaced in IE (and opera, maybe firefox?)
 *
 * FIXME: IE behaviour not yet implemented
 */
function get_attribute(elm, _, prop) {
  return elm.getAttribute(prop);
}

var Element = define_class('Element', VM.Object);
define_method(Element, 'collect', collect);
define_method(Element, 'get_attribute', get_attribute);
