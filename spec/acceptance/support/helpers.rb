module HelperMethods
  # Put here any helper method you need to be available in all your acceptance tests
  def within_section(header_text, &block)
    within("//section[./header[contains(., '#{header_text}')]]", &block)
  end
end

Spec::Runner.configuration.include(HelperMethods)
