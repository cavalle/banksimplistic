module CommandBus
private
  
  def execute_command(*args)
    DomainRepository.begin
    lookup_handler(args.shift).execute(*args)
    DomainRepository.commit
  end
  
  def lookup_handler(command_name)
    "#{command_name.to_s.camelize}CommandHandler".constantize.new
  end
end
