# opal-jquery

[![Build Status](https://secure.travis-ci.org/opal/opal-jquery.png?branch=master)](http://travis-ci.org/opal/opal-jquery)

opal-jquery provides DOM access to opal by wrapping jQuery (or zepto)
and providing a nice ruby syntax for dealing with jQuery instances.
opal-jquery is [hosted on github](http://github.com/opal/opal-jquery).

See the [website for documentation](http://opalrb.org/jquery).

## Documentation

```ruby
elements = Element.find('.foo')
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

#### Finding elements

opal-jquery provides the `Element` class, which can be used to find elements in
the current document:

```ruby
Element.find('#header')
```

`Element.find` is aliased to `Element[]`:

```ruby
Element['.my-class']
```

These methods acts just like `$('selector')`, and can use any jQuery
compatible selector:

```ruby
Element.find('#navigation li:last')
```

The result is just a jQuery instance, which is toll-free bridged to
instances of the `Element` class in ruby:

```ruby
Element.find('.foo').class
# => Element
```

Instances of `Element` also have the `#find` method available for
finding elements within the scope of each DOM node represented by
the instance:

```ruby
el = Element.find('#header')
el.find '.foo'
# => #<Element .... >
```

#### Running code on document ready

Just like jQuery, opal-jquery requires the document to be ready to
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
Element.find('#header').on :click do
  puts "The header was clicked!"
end
```

Selectors can also be passed as a second argument to handle events
on certain children:

```ruby
Element.find('#header').on(:click, '.foo') do
  puts "An element with a 'foo' class was clicked"
end
```

An `Event` instance is optionally passed to block handlers as well,
which is toll-free bridged to jquery events:

```ruby
Element.find('#my_link').on(:click) do |evt|
  evt.stop_propagation
  puts "stopped the event!"
end
```

#### CSS styles and classnames

The various jQuery methods are available on `Element` instances:

```ruby
foo = Element.find('.foo')

foo.add_class 'blue'
foo.remove_class 'foo'
foo.toggle_class 'selected'
```

There are also added convenience methods for opal-jquery:

```ruby
foo = Element.find('#header')

foo.class_name
# => 'red lorry'

foo.class_name = 'yellow house'

foo.class_name
# => 'yellow house'
```

`Element#css` also exists for getting/setting css styles:

```ruby
el = Element.find('#container')
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

Web apps deal with JSON responses quite frequently, so there is a useful
`#json` helper method to get the JSON content from a request:

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
### HTTP

The `HTTP` class wraps jQuery's ajax request into a ruby class.

```ruby
HTTP.get("/users/1.json") do |response|
  puts "Got response!"
end
```

## Running Specs

Get the dependencies:

    $ bundle install

### Browser

You can run the specs in any web browser, by running the `config.ru` rack file:

    $ bundle exec rackup

And then visiting `http://localhost:9292` in any web browser.

### Phantomjs

You will need phantomjs to run the specs outside the browser.  It can
be downloaded at [http://phantomjs.org/download.html](http://phantomjs.org/download.html)

On osx you can install through homebrew

    $ brew update; brew install phantomjs

Run the tests inside a phantom.js runner:

    $ bundle exec rake

### Zepto

opal-jquery also supports zepto. To run specs for zepto use the rake task:

    $ bundle exec rake zepto

##  License

(The MIT License)

Copyright (C) 2013 by Adam Beynon

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
