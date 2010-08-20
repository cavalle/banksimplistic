module DomainRepository

  class << self
    include RedisRepository
  
    def aggregates
      Thread.current[:"DomainRepositoryCurrentStore"]
    end
  
    def begin
      Thread.current[:"DomainRepositoryCurrentStore"] = []
    end
  
    def add(aggregate)
      self.aggregates << aggregate
      aggregate
    end
  
    def commit
      aggregates.each do |aggregate|
        while event = aggregate.applied_events.shift
          save event
          publish event
        end
      end
    end
    
    def method_missing(meth, *args, &blk)
      if meth.to_s =~ /^find_(.+)/
        find($1, args.first)
      else
        super
      end
    end
    
    private
    
    def find(type, uid)
      Event # force autoload or next `decode` will fail
      
      # We could detect here that an aggregate doesn't exist (it has no events) 
      # instead of inside the aggregate itself
      events = decode(lrange("fohjin:events:#{uid}", 0, -1)) || []
      
      type.camelize.constantize.build_from(events)
    end
    
    def save(event)
      lpush "fohjin:events:#{event.aggregate_uid}", encode(event)
    end
    
    def publish(event)
      EventBus.publish(event)
    end
    
  end
  
end