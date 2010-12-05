class CancelBankCardCommandHandler

  def execute(client_uid, card_number)
    client = DomainRepository.find_client(client_uid)
    client.cancel_card(card_number)
  end

end
