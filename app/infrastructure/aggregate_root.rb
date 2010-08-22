module AggregateRoot
  
  def self.included(base)
    base.class_eval do
      attr_accessor :uid
    end
    base.extend ClassMethods
  end
  
  module ClassMethods
    
    def build_from(events)
      object = self.new
      events.each do |event|
        object.send :do_apply, event
      end
      object
    end
    
    def new_uid
      UUIDTools::UUID.timestamp_create.to_s
    end
    
  end
  
  def applied_events
    @applied_events ||= []
  end
  
  def method_missing(meth, *args, &blk)
    if meth.to_s =~ /^should_(.+)/
      raise "#{self.class.name.titleize} should #{$1} but doesn't" unless self.send("#{$1}s?")
    else
      super
    end
  end
  
  def apply_event(name, attributes)
    event = Event.new(:name => name, :data => attributes)
    do_apply event
    event.aggregate_uid = uid
    applied_events << event
  end

  protected

  def do_apply(event)
    method_name = "on_#{event.name.to_s.underscore}".sub(/_event/,'')
    method(method_name).call(event)
  end
end