class ClientDetailsReport < Report
  attribute :name
  attribute :street
  attribute :postal_code
  attribute :city
  attribute :phone_number
  attribute :uid
  
  index :uid
  
  set :accounts, Account
  set :cards, Card
  set :cancelled_cards, Card

  class Account < Report
    attribute :name
    attribute :uid
    
    index :uid
  end

  class Card < Report
    attribute :card_number
    reference :account, Account

    index :card_number
  end

  on :account_created do |event|
    client = find(:uid => event.data[:client_uid]).first
    client.accounts << Account.create(event.data.slice(:uid, :name))
    client.save
  end
  
  on :client_created do |event|
    create event.data.slice(:name, :street, :postal_code, 
                            :city, :phone_number, :uid)
  end
  
  on :new_card_assigned do |event|
    client = find(:uid => event.data[:client_uid]).first
    account = Account.find(:uid => event.data[:account_uid]).first
    client.cards << Card.create(:account     => account, 
                                :card_number => event.data[:card_number])
  end

  on :client_name_changed do |event|
    client = find(:uid => event.data[:client_uid]).first
    client.update :name => event.data[:name]
  end
  
  on :card_cancelled do |event|
    client = find(:uid => event.data[:client_uid]).first
    card = client.cards.find(:card_number => event.data[:card_number]).first
    client.cards.delete(card)
    client.cancelled_cards << card
  end
end
