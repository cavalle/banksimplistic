Rails.configuration.event_bus = 'InProcessEventBus'
Rails.configuration.event_subscribers = %w{ClientReport ClientDetailsReport AccountDetailsReport MoneyTransferSaga}
Ohm.connect :url => ENV["REDISTOGO_URL"]
