Document.ready? do
  alerter = Element.id 'alerter'

  alerter.on :click do
    alert "You clicked me!"
  end
end