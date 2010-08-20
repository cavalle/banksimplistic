module Factories
  def create_client(attributes = {})
    execute_command :create_client, attributes
  end
  
  protected
  
  def execute_command(name, params)
    DomainRepository.begin
    result = "#{name}_command_handler".camelize.constantize.new.execute(params)
    DomainRepository.commit
    result
  end
  
end

Spec::Runner.configuration.include(Factories)