require 'rquery'

Document.ready? do
  Element['a'].click do |evt|
    alert "Thanks for visiting...."
  end
end

