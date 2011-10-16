module Commands
  def create_client(attributes = {})
    execute_command :create_client, attributes
  end
  
  def open_account(attributes = {})
    attributes = attributes.dup
    attributes[:client] ||= create_client
    client_id = attributes.delete(:client).uid
    execute_command :open_account, client_id, attributes
  end
  
  def deposit_cash(attributes = {})
    account_id = attributes.delete(:account).uid
    execute_command :deposit_cash, account_id, attributes
  end

  def assign_card(attributes = {})
    attributes = attributes.dup
    attributes[:client]  ||= create_client
    attributes[:account] ||= open_account(:client => attributes[:client])
    execute_command :assign_new_bank_card, attributes[:client].uid, attributes[:account].uid
  end
  
private
  
  def execute_command(*args)
    DomainRepository.begin
    result = "#{args.shift}_command_handler".camelize.constantize.new.execute(*args)
    DomainRepository.commit
    result
  end
  
end

RSpec.configuration.include Commands, :type => :acceptance
