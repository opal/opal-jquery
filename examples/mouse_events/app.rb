Document.ready? do
  count  = 0
  target = Element.id 'target'
  output = Element.id 'count'

  target.on :click do
    count += 1
    output.html = "Click count: #{count}"
  end
end