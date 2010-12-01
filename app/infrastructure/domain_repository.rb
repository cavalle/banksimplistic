module DomainRepository

  class << self
  
    def aggregates
      Thread.current[:"DomainRepositoryCurrentStore"]
    end
  
    def begin
      Thread.current[:"DomainRepositoryCurrentStore"] = Set.new
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
        find($1.camelize.constantize, args.first)
      else
        super
      end
    end
    
    def find(klass, uid)
      events = Event.find(:aggregate_uid => uid )
      
      # We could detect here that an aggregate doesn't exist (it has no events) 
      # instead of inside the aggregate itself
      
      add klass.build_from(events)
    end
    
    private
    
    def save(event)
      event.save
    end
    
    def publish(event)
      EventBus.publish(event)
    end
    
  end
  
end