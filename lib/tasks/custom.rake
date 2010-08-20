task :clear_data do
  require File.dirname(__FILE__) + "/../../config/environment"
  Ohm.flush
end