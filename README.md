# opal-jquery

Gives Opal access to jquery/zepto.

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