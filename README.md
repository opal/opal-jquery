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