module EventHandler
  def on(*events, &block)
    events.each do |event_name|
      ::EventBus.subscribe(event_name, "#{name}:#{increment_handlers_count}:#{event_name}", &block)
    end
  end
  
  def increment_handlers_count
    @handlers_count ||= 0
    @handlers_count += 1
  end
  
end
