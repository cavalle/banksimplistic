require 'carrot'
require 'mq'

class EventBus::AMQP
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
    sleep(0.15) # next_tick 
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
