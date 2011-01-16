module EventBus
  class << self
    attr_accessor :current
    delegate :publish, :subscribe, :wait_for_events, :start, :purge, :stop, :to => :current
  end
end

class InProcessEventBus
  def publish(event)
    subscriptions(event.name).each do |subscription|
      subscription.call(event)
    end
  end

  def subscriptions(event_name)
    @subscriptions ||= Hash.new
    @subscriptions[event_name] ||= Set.new
  end

  def subscribe(event_name, &handler)
    subscriptions(event_name) << handler
  end

  def wait_for_events; end
  def purge; end
  def start; end
  def stop; end
end

class RedisEventBus
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

class AMQPEventBus
  def publish(event)
    Carrot.queue('events').publish(event.id)
  end

  def subscriptions(event_name)
    @subscriptions ||= Hash.new
    @subscriptions[event_name.to_s] ||= Set.new
  end

  def subscribe(event_name, &handler)
    subscriptions(event_name.to_s) << handler
  end

  def wait_for_events
    sleep(0.1) # next_tick 
  end

  def purge
    Carrot.queue("events").purge
  end

  def start
    AMQP.start do
      MQ.new.queue("events").subscribe do |event_id|
        event = Event[event_id]
        subscriptions(event.name).each do |subscription|
          subscription.call(event)
        end
      end
    end
  end

  def stop
    AMQP.stop { EM.stop }
    wait_for_events
  end
end
