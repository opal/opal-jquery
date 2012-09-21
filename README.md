# opal-jquery

[![Build Status](https://secure.travis-ci.org/opal/opal-jquery.png?branch=master)](http://travis-ci.org/opal/opal-jquery)

opal-jquery provides DOM access to opal by wrapping jquery (or zepto)
and providing a nice ruby syntax for dealing with jquery instances.
opal-jquery is [hosted on github](http://github.com/opal/opal-jquery).

jQuery instances are toll-free bridged to instances of the ruby class
`JQuery`, so they can be used interchangeably. The `Document` module also
exists, which provides the simple top level css selector method:

```ruby
elements = Document['.foo']
# => [<div class="foo">, ...]

elements.class
# => JQuery

elements.on(:click) do
  alert "element was clicked"
end
```

### Getting Started

#### Installation

Install opal-jquery from RubyGems:

```
$ gem install opal-jquery
```

Or include it in your Gemfile for Bundler:

```ruby
gem 'opal-jquery'
```

### Interacting with the DOM

#### Finiding elements

opal-jquery provides the `Document` module, which is the best way to
find elements by css selector:

```ruby
Document['#header']
```

This method acts just like `$('selector')`, and can use any jquery
compatible selector:

```ruby
Document['#navigation li:last']
```

The result is just a jquery instance, which is toll-free bridged to
instances of the `Element` class in ruby:

```ruby
Document['.foo'].class
# => Element
```

Instances of `Element` also have the `#find` method available for
finding elements within the scope of each dom node represented by
the instance:

```ruby
el = Document['#header']
el.find '.foo'
# => #<Element .... >
```

#### Running code on document ready

Just like jquery, opal-jquery requires the document to be ready to
be able to fully interact with the page. Any top level access should
use the `ready?` method:

```ruby
Document.ready? do
  alert "document is ready to go!"
end
```

The `Kernel#alert` method is shown above too.

#### Event handling

The `Element#on` method is used to attach event handlers to elements:

```ruby
Document['#header'].on :click do
  puts "The header was clicked!"
end
```

Selectors can also be passed as a second argument to handle events
on certain children:

```ruby
Document['#header'].on(:click, '.foo') do
  puts "An element with a 'foo' class was clicked"
end
```

An `Event` instance is optionally passed to block handlers as well,
which is toll-free bridged to jquery events:

```ruby
Document['#my_link'].on(:click) do |evt|
  evt.stop_propagation
  puts "stopped the event!"
end
```

#### CSS styles and classnames

The various jquery methods are available on `Element` instances:

```ruby
foo = Document['.foo']

foo.add_class 'blue'
foo.remove_class 'foo'
foo.toggle_class 'selected'
```

There are also added convenience methods for opal-jquery:

```ruby
foo = Document['#header']

foo.class_name
# => 'red lorry'

foo.class_name = 'yellow house'

foo.class_name
# => 'yellow house'
```

`Element#css` also exists for getting/setting css styles:

```ruby
el = Document['#container']
el.css 'color', 'blue'
el.css 'color'
# => 'blue'
```

### HTTP/AJAX requests

jQuery's Ajax implementation is also wrapped in the top level HTTP
class.

```ruby
HTTP.get("/users/1.json") do |response|
  puts response.body
  # => "{\"name\": \"Adam Beynon\"}"
end
```

The block passed to this method is used as the handler when the request
succeeds, as well as when it fails. To determine whether the request
was successful, use the `ok?` method:

```ruby
HTTP.get("/users/2.json") do |response|
  if response.ok?
    alert "successful!"
  else
    alert "request failed :("
  end
end
```

It is also possible to use a different handler for each case:

```ruby
request = HTTP.get("/users/3.json")

request.callback {
  puts "Request worked!"
}

request.errback {
  puts "Request didn't work :("
}
```

The request is actually triggered inside the `HTTP.get` method, but due
to the async nature of the request, the callback and errback handlers can
be added anytime before the request returns.

#### Handling responses

Web apps deal with json responses quite frequently, so there is a useful
`#json` helper method to get the json content from a request:

```ruby
HTTP.get("/users.json") do |response|
  puts response.body
  puts response.json
end

# => "[{\"name\": \"Adam\"},{\"name\": \"Ben\"}]"
# => [{"name" => "Adam"}, {"name" => "Ben"}]
```

The `#body` method will always return the raw response string.

If an error is encountered, then the `#status_code` method will hold the
specific error code from the underlying request:

```ruby
request = HTTP.get("/users/3.json")

request.callback { puts "it worked!" }

request.errback { |response|
  puts "failed with status #{response.status_code}"
}
```

opal-jquery provides DOM access to opal by wrapping jquery
and providing a nice ruby syntax for dealing with jquery instances.
opal-jquery is [hosted on github](http://github.com/opal/opal-jquery).

See the [website for documentation](http://opal.github.com/opal-jquery).

### Running Specs

Get the dependencies:

    $ bundle install

Build dependencies, opal-jquery and it's specs into `build/`:

    $ rake opal

Run the tests inside a phantom.js runner:

    $ rake

###  License

Copyright (C) 2012 by Adam Beynon

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.