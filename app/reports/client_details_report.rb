class ClientDetailsReport < Report
  attribute :name
  attribute :street
  attribute :postal_code
  attribute :city
  attribute :phone_number
  attribute :uid
  
  index :uid
  
  list :accounts, Account
  list :cards, Card

  class Account < Report
    attribute :name
    attribute :uid
    
    index :uid
  end

  class Card < Report
    attribute :card_number
    reference :account, Account
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
end
