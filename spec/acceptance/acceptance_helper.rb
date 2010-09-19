require File.dirname(__FILE__) + "/../spec_helper"
require "steak"
require 'capybara/rails'

RSpec.configure do |config|
  config.include Capybara, :type => :acceptance
  config.before(:each) do
    Ohm.flush
  end
end

Capybara.save_and_open_page_path = File.join(Rails.root, 'tmp')

class Capybara::Session
  def success?
    status_code == 200
  end
end

# Put your acceptance spec helpers inside /spec/acceptance/support
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
