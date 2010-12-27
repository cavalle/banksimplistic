class CompensateFailedTransferCommandHandler
  def execute(account_uid, amount)
    account = DomainRepository.find_account(account_uid)
    account.compensate_failed_transfer(amount)
  end
end
