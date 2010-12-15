module HelperMethods
  def within_section(header_text, &block)
    within(:xpath, "//section[./header[contains(., '#{header_text}')]]", &block)
  end
  
  def have_link(options = {})
    have_xpath("//a[@href='#{options[:to]}']")
  end

  def process(*args)
    raise
  end
end

class Rack::Test::Session
  def get_with_event_waiting(*args, &block)
    EventBus.wait_for_events
    get_without_event_waiting(*args, &block)
  end
  alias_method_chain :get, :event_waiting
end

RSpec.configure do |config|
  config.before(:each) do
    Ohm.flush
    EventBus.purge
    @t = Thread.new { EventBus.start }
    @t.abort_on_exception = true
  end

  config.after(:each) do
    EventBus.stop
    @t.kill
  end

  config.include HelperMethods, :type => :acceptance
end
