# DOM is depreciated. Using any method here will yield an error.
class DOM
  def self.find(selector)
    puts "DOM.find is depreciated. Use Document.find or Document[]"
    Document[selector]
  end

  def self.id(id)
    puts "DOM.id is depreciated. Use Document.id()"
    Document.id(id)
  end

  def self.new(tag = 'div')
    puts "DOM.new is depreciated. Use Element.new"
    Element.new(tag)
  end

  def self.parse(str)
    puts "DOM.parse is depreciated. Use Document.parse"
    Document.parse str
  end
end