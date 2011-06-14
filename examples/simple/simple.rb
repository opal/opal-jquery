require 'rquery'

RQuery.ready? do
  RQuery['a'].click do |evt|
    alert "Thanks for visiting...."
  end
end

