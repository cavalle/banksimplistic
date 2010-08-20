module EventBus
  class << self
    
    def publish(event)
      subscriptions(event.name).each do |subscription|
        subscription.call(event)
      end
    end
    
    def subscriptions(event_name)
      @subscriptions ||= Hash.new
      @subscriptions[event_name] ||= Set.new
    end
    
    def subscribe(event_name, handler)
      subscriptions(event_name) << handler
    end
    
  end
end