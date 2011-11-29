var define_method = VM.define_method,
    define_module = VM.define_module;

/**
 * :call-seq:
 *    elm.__observe__( name, handler )   -> elm
 *
 * +name+ should be the event name, e.g. `mousedown`, and +handler+ is a proc
 * passed in as a normal argument used as the callback method.
 */
function observe(elm, name, handler) {
  if (elm.addEventListener) {
    elm.addEventListener(name, func, false);
  }
  else {
    elm.attachEvent('on' + name, func);
  }

  return elm;
}

//var DOMEvents = define_module('DOMEvents');
//define_method(DOMEvents, '__observe__', observe);

