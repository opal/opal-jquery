Document.ready? do
  count  = 0
  target = DOM('#target')
  output = DOM('#count')

  target.on :click do
    count += 1
    output.html = "Click count: #{count}"
  end
end