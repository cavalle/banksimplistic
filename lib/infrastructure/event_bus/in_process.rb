class EventBus::InProcess
  def publish(event)
    subscriptions(event.name).each do |subscription|
      subscription.call(event)
    end
  end

  def subscriptions(event_name)
    @subscriptions ||= Hash.new
    @subscriptions[event_name] ||= Set.new
  end

  def subscribe(event_name, handler_id, &handler)
    subscriptions(event_name) << handler
  end

  def wait_for_events; end
  def purge; end
  def start; end
  def stop; end
end