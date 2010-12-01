class Account
  include AggregateRoot
  
  def initialize
    @balance = 0
  end
  
  def deposite(amount)
    # Do some validation
    
    new_balance = @balance + amount
    
    publish :deposite_made, :amount      => amount, 
                            :new_balance => new_balance, 
                            :account_uid => uid
  end
  
  def on_deposite_made(event)
    @balance = event.data[:new_balance]
  end
  
  # ...
  
  def on_account_created(event)
    @uid = event.data[:uid]
  end
  
  def self.create(attributes)
    account = self.new
    account.apply_event :account_created, attributes.merge(:uid => new_uid)
    account
  end
  
end