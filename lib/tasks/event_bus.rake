desc "Start Event Bus"
task "event_bus:start" => :environment do
  AMQP.start { EventBus.start }
end
