class OpenAccountCommandHandler
  
  def execute(client_id, attributes)
    client = DomainRepository.find_client(client_id)
    account = client.open_account(attributes)
    DomainRepository.add(account)
  end
  
end