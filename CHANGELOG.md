# EDGE

*   Add `Browser::Window` class, and make `::Window` an instance of it.

*   Make `Document` include `Browser::DocumentMethods` which is a simple
    module to define custom methods for `Document`.

*   Cleanup HTTP implementation.

*   `Element#[]` and `Element#attr` now return `nil` for empty attributes,
    instead of returning an empty string.

*   Add `HTTP.setup` and `HTTP.setup=` to access `$.ajaxSetup`

*   Add PATCH and HEAD support to `HTTP`

*   Let `Element` accept previously defined `JQUERY_CLASS` and `JQUERY_SELECTOR`
    for environments such as node-webkit where `$` can't be found in the global object.

*   Add Promise support to `HTTP` get/post/put/delete methods. Also remove
    `HTTP#callback` and `#errback` methods.

# 0.2.0 - March 12, 2013

*   Add `Document.body` and `Document.head` shortcut to element instances.

*   Add `Event` methods: `prevented?`, `prevent`, `stopped?` and `stop` to
    replace longer javascript names.

*   Add `LocalStorage` implementation.

*   Fix `Element#data()` to return `nil` for an undefined data attribute
    instead of null.

*   Expose `#detach` method on `Element`.

# 0.1.2 - December 1, 2013

*   Support setting html content through `Element#html()`.

*   Add `Element` methods: `#get`, `#attr` and `#prop` by aliasing them to
    jquery implementations.

# 0.1.1 - November 11, 2013

*   Require `native` from stdlib for `HTTP` to use.

# 0.1.0 - November 3, 2013

*   Add `Window` and `$window` alias.

*   Support `Zepto` as well as `jQuery`.

*   `Event` is now a wrapper around native event from dom listeners.

# 0.0.9 - June 15, 2013

*   Revert earlier commit, and use `$document` as reference to jquery
    wrapped `document`.

*   Introduce Element.document as wrapped document element

*   Depreceate $document.title and $document.title=.

# 0.0.8 - May 2, 2013

*   Depreceate Document in favor of $document global.

*   Add HTTP.delete() for creating DELETE request.

# 0.0.7 - February 20, 2013

*   Add Element#method_missing which forwards missing calls to try and call
    method as a native jquery function/plugin.

*   Depreceate Document finder methods (Document.find, Document[]). The finder
    methods on Element now replace them. Updated specs to suit.
