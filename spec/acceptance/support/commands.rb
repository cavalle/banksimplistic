module Commands
  def create_client(attributes = {})
    execute_command :create_client, attributes
  end
  
  def open_account(attributes = {})
    client_id = attributes.delete(:client).try(:uid)
    execute_command :open_account, client_id, attributes
  end
  
  protected
  
  def execute_command(*args)
    DomainRepository.begin
    result = "#{args.shift}_command_handler".camelize.constantize.new.execute(*args)
    DomainRepository.commit
    result
  end
  
end

Spec::Runner.configuration.include(Commands)