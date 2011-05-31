require 'ffi-rzmq'

class EventBus::Zero
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
    sleep(0.15) # next_tick 
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
