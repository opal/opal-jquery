## 0.0.8 2013-05-02

*   Depreceate Document in favor of $document global.

*   Add HTTP.delete() for creating DELETE request.

## 0.0.7 2013-02-20

*   Add Element#method_missing which forwards missing calls to try and call
    method as a native jquery function/plugin.

*   Depreceate Document finder methods (Document.find, Document[]). The finder
    methods on Element now replace them. Updated specs to suit.
