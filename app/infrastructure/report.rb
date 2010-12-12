class Report < Ohm::Model
  extend ::EventHandler
  def self.find(*args)
    EventBus.wait_for_events unless handling_event?
    super
  end
end
