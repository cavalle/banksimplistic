class EventBus::Redis
  def publish(event)
    Redis.new.publish "events", event.id
  end

  def subscriptions(event_name)
    @subscriptions ||= Hash.new
    @subscriptions[event_name.to_s] ||= Set.new
  end

  def subscribe(event_name, &handler)
    subscriptions(event_name.to_s) << handler
  end

  def wait_for_events
    sleep(0.05) # next_tick 
  end

  def purge
    Redis.new.del "events"
  end

  def start
    Redis.new.subscribe("events") do |on|
      on.message do |channel, event_id|
        event = Event[event_id]
        subscriptions(event.name).each do |subscription|
          subscription.call(event)
        end
      end
    end
  end

  def stop; end
end
