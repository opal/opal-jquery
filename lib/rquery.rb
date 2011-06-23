# require 'opal_json'

require 'rquery/element'
require 'rquery/node_set'
require 'rquery/document'
require 'rquery/ready'
require 'rquery/event'
require 'rquery/event_dispatcher'

require 'rquery/http_request'

require 'rquery/core_ext/kernel'

module RQuery

  def self.[](selector)
    `var elms = Sizzle(selector);
    var nodes = [], Element = #{ Element };

    for (var i = 0, ii = elms.length; i < ii; i++) {
      nodes.push(#{ `Element`.from_native `elms[i]` });
    }

    return #{ElementSet.new `nodes` };`
  end

  def self.document
    return @document if @document

    `var doc = #{ Document.allocate };
    doc.$el = document;`

    @document = `doc`
  end
end

