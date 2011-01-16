class ChangeClientNameCommandHandler

  def execute(client_id, attrs)
    client = Client.find(client_id)
    client.change_name(attrs[:name])
  end
end
