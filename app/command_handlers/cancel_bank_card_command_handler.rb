class CancelBankCardCommandHandler

  def execute(client_uid, card_number)
    client = Client.find(client_uid)
    client.cancel_card(card_number)
  end

end
