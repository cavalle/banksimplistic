class ClientDetailsReport < Report
  attribute :name
  attribute :street
  attribute :postal_code
  attribute :city
  attribute :phone_number
  attribute :uid
  
  index :uid
  
  list :accounts, Account
  
  class Account < Report
    attribute :name
    attribute :uid
  end
  
  on :account_created do |event|
    client = find(:uid => event.attributes[:client_uid])[0]
    client.accounts << Account.create(event.attributes.slice(:uid, :name))
    client.save
  end
  
  on :client_created do |event|
    create event.attributes.slice(:name, :street, :postal_code, 
                                  :city, :phone_number, :uid)
  end
end