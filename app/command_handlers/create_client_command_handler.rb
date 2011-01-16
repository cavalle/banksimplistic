class CreateClientCommandHandler
  
  def execute(attributes)
    Client.create(attributes)
  end
  
end
