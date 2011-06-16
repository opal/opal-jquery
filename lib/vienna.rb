require 'opal_json'

require 'vienna/node'
require 'vienna/node_set'
require 'vienna/document'
require 'vienna/ready'
require 'vienna/event'

require 'vienna/http_request'

require 'vienna/core_ext/kernel'

module Vienna

  def self.[](selector)
    `var elms = Sizzle(selector);
    var nodes = [], Node = #{ Node };

    for (var i = 0, ii = elms.length; i < ii; i++) {
      nodes.push(#{ `Node`.from_native `elms[i]` });
    }

    return #{NodeSet.new `nodes` };`
  end

  def self.document
    return @document if @document

    `var doc = #{ Document.allocate };
    doc.$el = document;`

    @document = `doc`
  end
end

VN = Vienna

