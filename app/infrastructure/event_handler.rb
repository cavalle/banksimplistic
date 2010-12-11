module EventHandler
  def on(*events, &block)
    events.each do |event|
      ::EventBus.subscribe(event, block)
    end
  end
end
