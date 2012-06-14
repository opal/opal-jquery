Document.ready? do
  DOM('#alerter').on :click do
    alert "You clicked me!"
  end
end