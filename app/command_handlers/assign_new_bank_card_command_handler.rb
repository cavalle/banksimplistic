class AssignNewBankCardCommandHandler
  
  def execute(client_id, account_id)
    client = Client.find(client_id)
    client.assign_new_card_for_account(account_id)
  end
  
end
