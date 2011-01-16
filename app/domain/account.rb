class Account
  include Entity
  
  def initialize
    @balance = Balance.new
  end
  
  def self.create(attributes)
    account = self.new
    account.apply_event :account_created, attributes.merge(:uid => new_uid)
    account
  end
  
  def deposite(amount)
    self.should_exist
    
    new_balance = @balance.deposite(amount)
    apply_event :deposite, :amount      => amount, 
                           :new_balance => new_balance.amount, 
                           :account_uid => uid
  end

  def send_transfer(target, amount)
    self.should_exist

    new_balance = @balance.withdraw(amount)
    apply_event :transfer_sent, :target_account_uid => target,
                                :amount      => amount,
                                :new_balance => new_balance.amount,
                                :account_uid => uid
  end

  def receive_transfer(source, amount)
    self.should_exist

    new_balance = @balance.deposite(amount)
    apply_event :transfer_received, :source_account_uid => source,
                                    :amount      => amount,
                                    :new_balance => new_balance.amount,
                                    :account_uid => uid
  end

  def compensate_failed_transfer(amount)
    self.should_exist

    new_balance = @balance.deposite(amount)
    apply_event :failed_transfer_compensated, :amount      => amount,
                                              :new_balance => new_balance.amount,
                                              :account_uid => uid
  end
  
private
  
  def on_account_created(event)
    @uid = event.data[:uid]
  end
  
  def on_deposite(event)
    @balance = Balance.new(event.data[:new_balance])
  end

  def on_transfer_sent(event)
    @balance = Balance.new(event.data[:new_balance])
  end

  def on_transfer_received(event)
    @balance = Balance.new(event.data[:new_balance])
  end

  def on_failed_transfer_compensated(event)
    @balance = Balance.new(event.data[:new_balance])
  end
  
end
