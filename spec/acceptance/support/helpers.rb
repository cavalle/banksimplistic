module HelperMethods
  def within_section(header_text, &block)
    within("//section[./header[contains(., '#{header_text}')]]", &block)
  end
  
  def have_link(options = {})
    have_xpath("//a[@href='#{options[:to]}']")
  end
end

RSpec.configuration.include HelperMethods, :type => :acceptance
