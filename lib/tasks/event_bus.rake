desc "Start Event Bus"
task "event_bus:start" => :environment do
  EventBus.start
end

task "jobs:work" => "event_bus:start"
