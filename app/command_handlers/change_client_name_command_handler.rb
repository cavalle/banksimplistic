class ChangeClientNameCommandHandler

  def execute(client_id, attrs)
    client = DomainRepository.find_client(client_id)
    client.change_name(attrs[:name])
  end
end
