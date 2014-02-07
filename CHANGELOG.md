## edge

*   Add `Document.body` and `Document.head` shortcut to element instances.

*   Add `Event` methods: `prevented?`, `prevent`, `stopped?` and `stop` to
    replace longer javascript names.

*   Add `LocalStorage` implementation.

*   Fix Element#data() to return nil for an undefined data attribute instead
    of null.

## 0.1.2 2013-12-01

*   Support setting html content through `Element#html()`.

*   Add `Element` methods: `#get`, `#attr` and `#prop` by aliasing them to
    jquery implementations.

## 0.1.1 2013-11-11

*   Require `native` from stdlib for `HTTP` to use.

## 0.1.0 2013-11-03

*   Add `Window` and `$window` alias.

*   Support `Zepto` as well as `jQuery`.

*   `Event` is now a wrapper around native event from dom listeners.

## 0.0.9 2013-06-15

*   Revert earlier commit, and use `$document` as reference to jquery
    wrapped `document`.

*   Introduce Element.document as wrapped document element

*   Depreceate $document.title and $document.title=.

## 0.0.8 2013-05-02

*   Depreceate Document in favor of $document global.

*   Add HTTP.delete() for creating DELETE request.

## 0.0.7 2013-02-20

*   Add Element#method_missing which forwards missing calls to try and call
    method as a native jquery function/plugin.

*   Depreceate Document finder methods (Document.find, Document[]). The finder
    methods on Element now replace them. Updated specs to suit.
