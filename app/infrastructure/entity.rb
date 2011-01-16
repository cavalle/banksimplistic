module Entity
  
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
  
  def method_missing(meth, *args, &blk)
    if meth.to_s =~ /^should_([^_]+)(_.+)?/
      verb = $1
      predicate = $2
      method = "#{third_personize(verb)}#{predicate}?"
      raise "#{self.class.name.titleize} should #{verb}#{predicate.try(:humanize)} #{args.join(" ")}" unless self.send(method, *args)
    else
      super
    end
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
  
  def third_personize(verb)
    case verb
    when /have/ then "has"
    when /be/ then "is"
    when /s$/ then verb
    else
      "#{verb}s"
    end
  end
end
