Document.ready? do
  count  = 0
  output = Document["#count"]

  Document["#target"].on :click do
    count += 1
    output.html = "Click count: #{count}"
  end
end