class Report < Ohm::Model
  def self.on(event, &block)
    ::EventBus.subscribe(event, block)
  end
end