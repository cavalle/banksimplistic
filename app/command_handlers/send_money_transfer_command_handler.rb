class SendMoneyTransferCommandHandler
  def execute(account_uid, attributes)
    account = DomainRepository.find_account(account_uid)
    account.send_transfer(attributes[:target_account_id], attributes[:amount].to_i)
  end
end
