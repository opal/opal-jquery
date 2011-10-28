var rb_define_method = VM.define_method,
    rb_define_class  = VM.define_class,
    rb_from_native   = VM.from_native;

var rb_cElement;

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
function elm_collect(elm, _, prop) {
  var result = [];

  while (elm = elm[prop]) {
    if (elm.nodeType === 1) {
      result.push(rb_from_native(rb_cElement, elm));
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
function elm_collect_one(elm, _, prop) {
  while (elm = elm[prop]) {
    if (elm.nodeType === 1) {
      return rb_from_native(rb_cElement, elm);
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
function elm_get_attribute(elm, _, prop) {
  return elm.getAttribute(prop);
}

rb_cElement = rb_define_class('Element', VM.Object);
rb_define_method(rb_cElement, 'collect', elm_collect);
rb_define_method(rb_cElement, 'get_attribute', elm_get_attribute);

