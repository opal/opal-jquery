module Vienna
  class NodeSet < Array

    def initialize(nodes)
      push *nodes
    end
  end
end

