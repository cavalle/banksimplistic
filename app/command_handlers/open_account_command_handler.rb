class OpenAccountCommandHandler
  
  def execute(params)
    client = DomainRepository.find_client(params[:client_id])
    account = client.create_account(params[:account])
    DomainRepository.add(account)
  end
  
end