require File.dirname(__FILE__) + "/../spec_helper"
require "steak"
require 'capybara/rails'
require 'webmock/rspec'

RSpec.configure do |config|
  config.include Capybara, :type => :acceptance

  config.before(:each) do
    Ohm.flush
  end

  config.after(:each) do
    Capybara.reset_sessions!
  end
end

Eventwire.on_error do |ex|
  raise ex
end

Capybara.app = Proc.new { |env|
  Rails.application.call(env)
}

Capybara.default_driver = ENV['DRIVER'].to_sym if ENV['DRIVER']

WebMock.disable_net_connect! :allow_localhost => true

# Put your acceptance spec helpers inside /spec/acceptance/support
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
