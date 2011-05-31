Rails.application.class.configure do
  config.event_bus = 'EventBus::Redis'
  config.event_subscribers = %w{ClientReport ClientDetailsReport AccountDetailsReport MoneyTransferSaga}
  config.to_prepare { EventBus.init }
end
