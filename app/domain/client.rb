class Client
  include AggregateRoot
  
  def self.create(attributes)
    client = self.new
    client.apply_event :client_created, attributes.merge(:uid => new_uid)
    client
  end
  
  def create_account(attributes)
    self.should_exist
    account = Account.create(attributes.merge(:client_uid => uid))
    apply_event :account_assigned_to_client, :account_id => account.uid
    account
  end
  
  def exists?
    self.uid.present?
  end
  
  def on_client_created(event)
    self.uid = event.attributes[:uid]
    # ...set the rest of attributes if we need it in the domain (chances are we don't)
  end
  
  def on_account_assigned_to_client(event)
    # no changes in state yet
  end
  
end