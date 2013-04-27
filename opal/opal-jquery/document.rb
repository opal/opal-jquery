module Document
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
