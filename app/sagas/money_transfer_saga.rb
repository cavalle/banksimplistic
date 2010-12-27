class MoneyTransferSaga
  extend EventHandler
  extend CommandBus

  on :transfer_sent do |event|
    if internal_account?(event.data[:target_account_uid])
      execute_command :receive_money_transfer, event.data[:target_account_uid],
                                               :from_account_uid => event.data[:account_uid], 
                                               :amount => event.data[:amount]
    else
      response = Net::HTTP.post_form URI.parse("http://banking-system.example.com/accounts/#{event.data[:target_account_uid]}"),
                                     :from => event.data[:account_uid], :amount => event.data[:amount]

      unless response.is_a?(Net::HTTPSuccess)
        execute_command :compensate_failed_transfer, event.data[:account_uid], event.data[:amount]
      end
    end
  end

  def self.internal_account?(account_uid)
    AccountDetailsReport.find(:uid => account_uid).any?
  end
end
