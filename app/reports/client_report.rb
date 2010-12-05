class ClientReport < Report
  attribute :name
  attribute :city
  attribute :uid

  index :uid
  
  on :client_created do |event|
    create event.data.slice(:name, :city, :uid)
  end

  on :client_name_changed do |event|
    client = find(:uid => event.data[:client_uid]).first
    client.update :name => event.data[:name]
  end
end

