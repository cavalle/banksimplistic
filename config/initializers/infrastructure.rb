Rails.configuration.event_bus = 'RedisEventBus'
Rails.configuration.event_subscribers = ClientReport, ClientDetailsReport, AccountDetailsReport, MoneyTransferSaga
