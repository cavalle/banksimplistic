class ClientReport < Report
  attribute :name
  attribute :city
  attribute :uid
  
  on :client_created do |event|
    create event.data.slice(:name, :city, :uid)
  end

end

