class Account
  include AggregateRoot
  
  def self.create(attributes)
    account = self.new
    account.apply_event :account_created, attributes.merge(:uid => new_uid)
    account
  end
  
  def on_account_created(event)
    self.uid = event.data[:uid]
  end
end