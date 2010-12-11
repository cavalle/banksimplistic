class MoneyTransferSaga
  extend EventHandler
  extend CommandBus

  on :transfer_sent do |event|
    execute_command :receive_money_transfer, event.data[:target_account_uid],
                                             :from_account_uid => event.data[:account_uid], 
                                             :amount => event.data[:amount]
  end
end
