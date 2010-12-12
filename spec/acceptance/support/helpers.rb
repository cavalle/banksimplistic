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

RSpec.configuration.before do
  Bunny.run { |c| c.queue("events").purge }
end

RSpec.configuration.include HelperMethods, :type => :acceptance
