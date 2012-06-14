# opal-dom

opal-dom is a jQuery wrapper for Opal, which gives ruby access to the
DOM. It is also compatible with zepto.

## DOM

The `DOM` class is toll-free bridged onto instances of jquery. This
means that any jquery object is also an `DOM` instance, and both
can be used interoperably. It will bridge to zepto if jquery is not
present.

This also means that an `DOM` instance actually represents 0 or
more real elements from the document.

### Finding Elements

The `Kernel` method `DOM()` is directly mapped to the `$()` function
so it can be used to find elements by id, CSS selector or to parse
raw HTML string into a DOM instance:

```ruby
# search for an element by id
DOM('#foo')                 => [<div id="foo">]

# search for all matching elements
DOM('.bar')                 => [<p class="bar">, <p class="bar">]

# parse html string into element
DOM('<p id="baz">Hey</p>')  => [<p id="baz">] 
```

There are also two handy methods for quickly getting access to
elements:

```ruby
DOM.id 'foo'
# => [<div id="foo">]
```

This will get the element with the given id and return a new `DOM`
instance (jquery object) that wraps the matched element. If no element
with the given id was found, then nil is returned.

To find multiple elements, using a class name for instance, you can
use:

```ruby
DOM.find '.some-class'
# => [<div id="apple" class="some-class">, <div class="some-class">]
```

Any valid css selector that works with jquery can be used with `.find`.

Finally, you can create a new element using the normal constructor:

```ruby
DOM.new       # => [<div>]
DOM.new 'p'   # => [<div>]
```

### Interacting with elements

#### CSS class names

```html
<div id="foo" class="bar"></div>
```

```ruby
el = DOM.id 'foo'

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
foo = DOM.id 'foo'

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
foo = DOM.id 'foo'

foo[:title]                 # => "Hello"
foo[:title] = "Goodbye"
foo[:title]                 # => "Goodbye"
```

Strings and symbols can be used for the names interchangeably. If the
requested attribute does not exist, then `nil` is returned.

## License

opal-dom is released under the MIT License