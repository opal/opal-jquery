module Document
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
end