class Account
  include AggregateRoot
  
  def self.create(attributes)
    account = self.new
    account.apply_event :account_created, attributes.merge(:uid => new_uid)
    account
  end
  
  def on_account_created(event)
    self.uid = event.attributes[:uid]
    # ...set the rest of attributes if we need it in the domain (chances are we don't)
  end
end