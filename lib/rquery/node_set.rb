module RQuery
  class ElementSet < Array

    def initialize(nodes)
      push *nodes
    end
  end
end

