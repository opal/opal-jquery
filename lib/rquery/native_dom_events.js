// make things a little more readable/minimizable
var rb_define_method = VM.define_method,
    rb_define_module = VM.define_module;

var rb_mDOMEvents;

/**
 * :call-seq:
 *    elm.__observe__( name, handler )   -> elm
 *
 * +name+ should be the event name, e.g. `mousedown`, and +handler+ is a proc
 * passed in as a normal argument used as the callback method.
 */
function evt_observe(elm, _, name, handler) {
  if (elm.addEventListener) {
    elm.addEventListener(name, func, false);
  }
  else {
    elm.attachEvent('on' + name, func);
  }

  return elm;
}

rb_mDOMEvents = rb_define_module('DOMEvents');
rb_define_method(rb_mDOMEvents, '__observe__', evt_observe);

