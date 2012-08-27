# opal-jquery

[![Build Status](https://secure.travis-ci.org/adambeynon/opal-jquery.png?branch=master)](http://travis-ci.org/adambeynon/opal-jquery)

Gives Opal access to jquery/zepto.

## JQuery

Instances of the `JQuery` class are just jquery/zepto objects. This
means that all methods of `JQuery` are copied onto the jquery
prototype so any instance can be used inside opal, and any opal version
in javascript.

## Finding elements

### General selectors

```ruby
Document['.foo']
# => (<div class="foo bar">, <div class="foo">)
```

### By id

```ruby
Document.id 'bar'
# => (<div id="bar">)
Document.id 'doesnt-exist'
# => nil
```

```ruby
Document['#foo'].on :click do
  puts "foo was clicked"
end
```

## HTTP (Ajax) requests

The `HTTP` class is provided which wraps simple jquery ajax requests.

```ruby
HTTP.get("/users/1.json") do |response|
  puts response.body
  # => "{\"name\": \"Adam Beynon\"}"
end
```

By default, the block will be called when the request is successfull
and when it fails. To test whether the response was a success, use the
`ok?` method:

```ruby
HTTP.get("/users/1.json") do |response|
  if response.ok?
    alert "Success!"
  else
    alert "Error (#{response.status_code})"
  end
end
```

Here the `status_code` is also used to report the error.

For JSON responses, the `json` method is useful for parsing the response
body into ruby objects (Hash, Array, String, etc):

```ruby
HTTP.get("/users/1.json") do |response|
  puts response.json
end

# => { "name": "Adam Beynon", "age": 26, "id": 1 }
```