class DepositCashCommandHandler
  def execute(account_uid, attributes)
    account = Account.find(account_uid)
    account.deposite(attributes[:amount].to_i)
  end
end
