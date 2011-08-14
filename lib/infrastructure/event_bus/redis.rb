require 'redis'
require 'em-redis'

class EventBus::Redis
  def publish(event)
    Redis.new.rpush event.name, event.id
  end

  def initialize
    @subscriptions = []
    @handlers = []
  end

  def subscribe(event_name, handler_id, &handler)
    @subscriptions << [event_name.to_s, handler_id]
    @handlers << [handler_id, handler]
  end

  def wait_for_events
    7.times { next_tick }
  end
  
  def next_tick
    return unless EM.reactor_running?    
    t = Thread.current
    EM.next_tick { t.wakeup }
    Thread.stop
  end

  def purge
    redis = Redis.new
    all_queues.each do |queue|
      redis.del queue
    end
  end
  
  def all_queues
    (@subscriptions + @handlers).map(&:first).uniq
  end

  def start
    EM.run do
      redis = EM::Protocols::Redis.connect
      
      @subscriptions.group_by(&:first).each do |event, subscriptions|
        subscribe_to_queue redis, event do |event_id|
          subscriptions.each do |event, queue|
            redis.rpush queue, event_id
          end
        end
      end
      
      @handlers.each do |queue, handler|
        subscribe_to_queue redis, queue do |event_id|
          handler.call Event[event_id]
        end
      end
      
    end
  end
  
  def subscribe_to_queue(redis, queue, &block)
    callback = Proc.new do |response|
      block.call(response) if response
      redis.lpop(queue, &callback)
    end
    redis.lpop(queue, &callback)
  end

  def stop
    EM.stop
  end
end
