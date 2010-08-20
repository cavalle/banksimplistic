class CreateClientCommandHandler
  
  def execute(attributes)
    client = Client.create(attributes)
    DomainRepository.add(client)
  end
  
end