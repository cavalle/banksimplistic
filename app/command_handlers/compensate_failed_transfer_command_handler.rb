class CompensateFailedTransferCommandHandler
  def execute(account_uid, amount)
    account = Account.find(account_uid)
    account.compensate_failed_transfer(amount)
  end
end
