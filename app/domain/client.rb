class Client
  include Entity
  
  def initialize
    @account_uids = []
    @card_numbers = []
  end
  
  def self.create(attributes)
    client = self.new
    client.apply_event :client_created, attributes.merge(:uid => new_uid)
    client
  end
  
  def open_account(attributes)
    self.should_exist
    
    account = Account.create(attributes.merge(:client_uid => uid))
    apply_event :account_assigned_to_client, :account_uid => account.uid
    account
  end
  
  def assign_new_card_for_account(account_uid)
    self.should_exist
    self.should_own_account account_uid

    card = BankCard.create(uid)
    apply_event :new_card_assigned, :client_uid  => uid,
                                    :account_uid => account_uid,
                                    :card_number => card.number
  end

  def change_name(new_name)
    self.should_exist

    apply_event :client_name_changed, :client_uid => uid,
                                      :name => new_name
  end

  def cancel_card(card_number)
    self.should_exist
    self.should_own_card card_number

    BankCard.find(card_number).cancel
  end
  
private
  
  def owns_account?(account_uid)
    @account_uids.include? account_uid
  end

  def owns_card?(card_number)
    @card_numbers.include? card_number
  end
  
  def on_client_created(event)
    @uid = event.data[:uid]
  end
  
  def on_account_assigned_to_client(event)
    @account_uids << event.data[:account_uid]
  end
  
  def on_new_card_assigned(event)
    @card_numbers << event.data[:card_number]
  end

  def on_client_name_changed(event)
    # no need to change state
  end

end
