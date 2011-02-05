Rails.configuration.event_bus = 'RedisEventBus'
Rails.configuration.event_subscribers = %w{ClientReport ClientDetailsReport AccountDetailsReport MoneyTransferSaga}
