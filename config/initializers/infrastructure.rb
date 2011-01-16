EventBus.current = RedisEventBus.new

# Force autoloading of Event Subscribers:
ClientReport; ClientDetailsReport; AccountDetailsReport
MoneyTransferSaga

