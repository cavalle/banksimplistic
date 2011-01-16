class OpenAccountCommandHandler
  
  def execute(client_id, attributes)
    client = Client.find(client_id)
    account = client.open_account(attributes)
  end
  
end
