module EventBus
  class << self

    def mq
      Qusion.channel
    end
    
    def publish(event)
      Bunny.run { |c| c.queue('events').publish(YAML.dump(event)) }
    end
    
    def subscriptions(event_name)
      @subscriptions ||= Hash.new
      @subscriptions[event_name] ||= Set.new
    end
    
    def subscribe(event_name, &handler)
      subscriptions(event_name) << handler
    end

    def wait_for_events
      Bunny.run {|c| sleep(0.1) until c.queue("events").status[:message_count] == 0 }
    end

    def start
      mq.queue("events").subscribe do |event|
        event = YAML.load(event)
        subscriptions(event.name).each do |subscription|
          subscription.call(event)
        end
      end
    end
  end
end
