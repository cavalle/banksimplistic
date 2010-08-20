require File.dirname(__FILE__) + "/../spec_helper"
require "steak"
require 'capybara/rails'

Spec::Runner.configure do |config|
  config.include Capybara 
  config.before(:each) do
    Ohm.flush
  end
end

Capybara.save_and_open_page_path = File.join(RAILS_ROOT,'tmp')

# Put your acceptance spec helpers inside /spec/acceptance/support
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
