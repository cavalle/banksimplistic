module EventHandler
  def on(*events, &block)
    events.each do |event_name|
      ::EventBus.subscribe(event_name) do |event|
        begin
          self.handling_event = true
          block.call(event)
        ensure
          self.handling_event = false
        end
      end
    end
  end

  def handling_event?
    Thread.current["handling_event"]
  end

  def handling_event=(value)
    Thread.current["handling_event"] = value
  end
end
