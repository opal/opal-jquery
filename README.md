# opal-jquery: jQuery Wrapper For Opal

[![Build Status](http://img.shields.io/travis/opal/opal-jquery/master.svg)](http://travis-ci.org/opal/opal-jquery)

opal-jquery provides DOM access to opal by wrapping jQuery (or zepto)
and providing a nice ruby syntax for dealing with jQuery instances.

See the Opal website for [documentation](http://opalrb.org/docs/jquery).

## Installation

Install opal-jquery from RubyGems:

```
$ gem install opal-jquery
```

Or include it in your Gemfile for Bundler:

```ruby
gem 'opal-jquery'
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

## Getting Started

### Usage

`opal-jquery` can now be easily added to your opal application sources using a
standard require:

```ruby
# app/application.rb
require 'opal'
require 'jquery'
require 'opal-jquery'

alert "Hello from jquery + opal"
```

> **Note**: this file requires two important dependencies, `jquery` and `opal-jquery`.
> You need to bring your own `jquery.js` file as the gem does not include one. If
> you are using the asset pipeline with rails, then this should be available
> already, otherwise download a copy and place it into `app/` or whichever directory
> you are compiling assets from. You can alternatively require a zepto instance.

The `#alert` method is provided by `opal-jquery`. If the message displays, then
`jquery` support should be working.

### How does opal-jquery work

`opal-jquery` provides an `Element` class, whose instances are toll-free
bridged instances of jquery objects. Just like ruby arrays are just javascript
arrays, `Element` instances are just jquery objects. This makes interaction
with jquery plugins much easier.

Also, `Element` will try to bridge with Zepto if it cannot find jQuery loaded,
making it ideal for mobile applications as well.

## Interacting with the DOM

### Finding Elements

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

### Running code on document ready

Just like jQuery, opal-jquery requires the document to be ready to
be able to fully interact with the page. Any top level access should
use the `ready?` method:

```ruby
Document.ready? do
  alert "document is ready to go!"
end
```

Document.ready (without the question mark) returns the equivilent promise. 
Like other promises it can be combined using the when and then methods.

```ruby
Document.ready.then do |ready|
  puts "Page is ready to use!"
end
```

The `Kernel#alert` method is shown above too.

### Event handling

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

You can access the element which triggered the event by `#current_target`.

```ruby
Document.on :click do |evt|
  puts "clicked on: #{evt.current_target}"
end
```

### CSS styles and classnames

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

## HTTP/AJAX requests

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

### Handling responses

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

## Usage of JQuery plugins
Extra plugins used for JQuery aren't available to ruby code by default, you will have to `expose` these functions to opal-jquery.

```ruby
Element.expose :cool_plugin
```

Arguments to a `exposed` function will be passed as they are, so these arguments will have to be passed as native JS instead of ruby code. A conversion to native JS can be done with the `.to_n` method.

```ruby
Element.expose :cool_plugin

el = Element['.html_element']
el.cool_plugin({argument: 'value', argument1: 1000}.to_n)
```

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

