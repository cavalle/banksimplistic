class ClientReport < Report
  attribute :name
  attribute :city
  attribute :uid
  
  on :client_created do |event|
    create event.attributes.slice(:name, :city, :uid)
  end

end

