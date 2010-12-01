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
    
    def find(id)
      DomainRepository.find(self, id)
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
      method = "#{third_personize($1)}#{$2}?"
      raise "#{self.class.name.titleize} should #{verb}#{predicate.humanize} #{args.join(" ")} but that's not happening" unless self.send(method, *args)
    else
      super
    end
  end
  
  def publish(name, attributes)
    event = Event.new(:name => name, :data => attributes)
    do_apply event
    event.aggregate_uid = uid
    published_events << event
  end
  
  alias apply_event publish
  alias published_events applied_events

  protected

  def do_apply(event)
    method_name = "on_#{event.name.to_s.underscore}".sub(/_event/,'')
    method(method_name).call(event)
  end
  
  def third_personize(verb)
    case verb
    when /have/ then "has"
    when /s$/ then verb
    else
      "#{verb}s"
    end
  end
  
  public
  
  ### ActiveModel Compliance ###
  ClassMethods.send :include, ActiveModel::Naming
  def to_model; self; end
  def to_key; uid; end
  def to_param; uid; end
  
end