Ohm.connect :url => ENV["REDISTOGO_URL"]

Rails.application.class.configure do
  config.event_bus = 'RedisEventBus'
  config.event_subscribers = %w{ClientReport ClientDetailsReport AccountDetailsReport MoneyTransferSaga}
  config.to_prepare { EventBus.init }
end
