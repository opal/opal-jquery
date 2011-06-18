module Vienna

  module EventDispatcher

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      def dispatch(event)
        define_method(event) do |&blk|
          upon event, &blk
          self
        end
      end
    end # ClassMethods

    def upon(event, &block)
      @event_dispatchers ||= {}
      @event_dispatchers[event] ||= []
      @event_dispatchers[event] << block
    end

    def trigger(event)
      dispatchers = @event_dispatchers
      return unless dispatchers && dispatchers[event]
      dispatchers[event].each { |b| b.call }
    end
  end
end

