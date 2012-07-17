# module Document
#   def self.body_ready?
#     `!!(document && document.body)`
#   end

#   def self.ready?(&block)
#     %x{
#       if (block === nil) {
#         return nil;
#       }

#       $(function() {
#         #{ block.call };
#       });

#       return nil;
#     }
#   end
# end