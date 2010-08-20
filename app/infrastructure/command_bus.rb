module CommandBus
  def execute_command(name, attributes)
    DomainRepository.begin
    lookup_handler(name).execute(attributes)
    DomainRepository.commit
  end
  
  def lookup_handler(command_name)
    "#{command_name.to_s.camelize}CommandHandler".constantize.new
  end
end