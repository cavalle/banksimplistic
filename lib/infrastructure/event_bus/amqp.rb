require 'amqp'
require 'bunny'

class EventBus::AMQP

  def publish(event)
    Bunny.run do |mq|
      mq.exchange(event.name, :type => :fanout).publish(event.id)
    end    
  end

  def subscribe(event_name, handler_id, &handler)
    subscriptions << Subscription.new(event_name, handler_id, handler)
  end

  def wait_for_events    
    return unless EM.reactor_running?    
    next_tick = false
    EM.next_tick { next_tick = true }
    sleep 0.002 until next_tick
  end

  def purge
    Bunny.run do |mq|
      subscriptions.each { |s| s.purge(mq) }
    end
  end

  def start
    AMQP.start do
      subscriptions.each { |s| s.subscribe(MQ) }
    end
  end

  def stop
    AMQP.stop { EM.stop }
  end
  
  private
  
  def subscriptions
    @subscriptions ||= []
  end
  
  class Subscription < Struct.new(:event, :queue, :handler)
    
    def subscribe(mq)
      mq.queue(queue).bind(mq.fanout(event)).subscribe do |event_id|
        handler.call Event[event_id]
      end
    end
    
    def purge(mq)
      mq.queue(queue).purge
    end
      
  end
  
end
