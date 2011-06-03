# require 'opal-json'

require 'rquery/element'
require 'rquery/document'
require 'rquery/event'
require 'rquery/request'
require 'rquery/response'

require 'rquery/core_ext/kernel'

e = RQuery['#wow']
puts e

f = RQuery.find 'div'
puts f

g = rquery :haaaaa
puts g


h = rquery.document
puts h

i = RQuery.allocate
puts i
puts "i.end should be document"
puts i.end
puts i.end.inspect

z = f.find 'div'
puts z

z.add_class 'title'
z.first.first.last.first.remove_class 'title'
puts z.first.has_class? 'title'
puts z.has_class? 'title'

first = z.first
puts "first is #{first}"
puts first.next.inspect

second = z[1]
puts "second is #{second}"
puts second.next

puts "finding next for all"
puts z.next

