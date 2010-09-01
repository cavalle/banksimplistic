class DepositCashCommandHandler
  def execute(account_uid, attributes)
    account = DomainRepository.find_account(account_uid)
    account.deposite(attributes[:amount].to_i)
  end
end