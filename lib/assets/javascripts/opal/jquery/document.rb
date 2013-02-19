module Document
  def self.[](selector)
    puts "Document[] is now depreceated. Use Element[]"
    Element[selector]
  end

  def self.find(selector)
    puts "Document.find is now depreceated. Use Element.find"
    Element.find(selector)
  end

  def self.id(id)
    puts "Document.id is now depreceated. Use Element.id"
    Element.id(id)
  end

  def self.parse(str)
    puts "Document.parse is now depreceated. Use Element.parse"
    Element.parse(str)
  end

  def self.ready?(&block)
    %x{
      if (block === nil) {
        return nil;
      }

      $(block);
      return nil;
    }
  end

  def self.title
    `document.title`
  end

  def self.title=(title)
    `document.title = title`
  end
end
