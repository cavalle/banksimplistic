class ReceiveMoneyTransferCommandHandler
  def execute(account_uid, attributes)
    account = DomainRepository.find_account(account_uid)
    account.receive_transfer(attributes[:from_account_uid], attributes[:amount].to_i)
  end
end
