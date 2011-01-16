module AggregateRoot
  include Validable
  
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

    def find(uid)
      DomainRepository.find(self.name.underscore, uid)
    end
    
  end
  
  def exists?
    self.uid.present?
  end
  
  def applied_events
    @applied_events ||= []
  end
  
  def apply_event(name, attributes)
    event = Event.new(:name => name, :data => attributes)
    do_apply event
    event.aggregate_uid = uid
    applied_events << event
    DomainRepository.add(self)
  end

private

  def do_apply(event)
    method_name = "on_#{event.name.to_s.underscore}".sub(/_event/,'')
    method(method_name).call(event)
  end

end
