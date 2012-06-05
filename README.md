# RQuery

RQuery is a jQuery wrapper for Opal, which gives ruby access to the DOM.

## Element

The `Element` class is toll-free bridged onto instances of jquery. This
means that any jquery object is also an `Element` instance, and both
can be used interoperably.

This also means that an `Element` instance actually represents 0 or
more real elements from the document.

### Finding Elements

There are two handy methods for quickly getting access to elements:

```ruby
Element.id 'foo'
# => [<div id="foo">]
```

This will get the element with the given id and return a new `Element`
instance (jquery object) that wraps the matched element. If no element
with the given id was found, then nil is returned.

To find multiple elements, using a class name for instance, you can
use:

```ruby
Element.find '.some-class'
# => [<div id="apple" class="some-class">, <div class="some-class">]
```

Any valid css selector that works with jquery can be used with `.find`.

Finally, you can create a new element using the normal constructor:

```ruby
Element.new       # => [<div>]
Element.new 'p'   # => [<div>]
```

### Interacting with elements

#### CSS class names

```html
<div id="foo" class="bar"></div>
```

```ruby
el = Element.id 'foo'

el.class_name           # => true
el.has_class? 'woosh'   # => false

el.class_name = 'woosh'
el.has_class? 'woosh'   # => true

el.add_class 'kapow'
el.class_name           # => "woosh kapow"

el.remove_class 'woosh'
el.class_name           # => "kapow"
```

#### CSS Styles

```html
<div id="foo" style="color:red"></div>
```

```ruby
foo = Element.id 'foo'

foo.css 'color'           # => "red"
foo.css 'color', 'blue'
foo.css 'color'           # => "blue"
```

Of course there will be browser differences as some browsers return
RGB colors, some hex colors and some return the real name.

#### Attributes

Accessing attributes (jquery `attr()` method) is a little easier in
rquery:

```html
<div id="foo" title="Hello"></div>
```

```ruby
foo = Element.id 'foo'

foo[:title]                 # => "Hello"
foo[:title] = "Goodbye"
foo[:title]                 # => "Goodbye"
```

Strings and symbols can be used for the names interchangeably. If the
requested attribute does not exist, then `nil` is returned.

## License

RQuery is released under the MIT License