Document.ready? do
  Document['#alerter'].on :click do
    alert "You clicked me!"
  end
end