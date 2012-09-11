module Document
  def self.[](selector)
    `$(#{selector})`
  end

  def self.find(selector)
    self[selector]
  end

  def self.id(id)
    %x{
      var el = document.getElementById(id);

      if (!el) {
        return nil;
      }

      return $(el);
    }
  end

  def self.parse(str)
    `$(str)`
  end

  def self.ready?(&block)
    %x{
      if (block === nil) {
        return nil;
      }

      $(function() {
        #{ block.call };
      });

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