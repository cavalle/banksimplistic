module EventBus
  class << self
    attr_accessor :current
    delegate :publish, :subscribe, :wait_for_events, :start, :purge, :stop, :to => :current

    def init
      EventBus.current = Rails.configuration.event_bus.constantize.new
      Rails.configuration.event_subscribers.each(&:constantize)
    end
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
  
  def redis
    if ENV["REDISTOGO_URL"]
      uri = URI.parse(ENV["REDISTOGO_URL"])
      Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
    else
      Redis.new
    end
  end
  
  def publish(event)
    redis.publish "events", event.id
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
    redis.del "events"
  end

  def start
    redis.subscribe("events") do |on|
      on.message do |channel, event_id|
        event = Event.find(event_id)
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

class ZeroMQEventBus
  def publish(event)
    ctx = ZMQ::Context.new
    s = ctx.socket ZMQ::PUSH
    s.connect("tcp://127.0.0.1:5560")
    s.send_string(event.id.to_s)
    
    # Release socket after a delay since ZMQ
    # doesn't flush if we close right away
    Thread.new do
      sleep(1)
      s.close
      ctx.terminate
    end
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
  end

  def start
    ctx = ZMQ::Context.new
    s = ctx.socket ZMQ::PULL
    s.bind("tcp://127.0.0.1:5560")
    @running = true
    while @running
      event_id = s.recv_string(ZMQ::NOBLOCK)
      next unless event_id
      event = Event[event_id]
      subscriptions(event.name).each do |subscription|
        subscription.call(event)
      end
    end
  ensure
    s.close
    ctx.terminate
  end

  def stop
    @running = false
    sleep(0.1) until available_port?('127.0.0.1', 5560) 
  end

  private

  def available_port?(host, port)
    server = TCPServer.new(host, port)
    return true
  rescue
    return false
  ensure
    server.close if server
  end
end
