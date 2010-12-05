RSpec::Matchers.define :be_success do |zone|
  match do |page|
    @status = page.status_code
    @status == 200
  end
  failure_message_for_should do |player|
    "Page status should be 200 but it was #{@status}"
  end
  failure_message_for_should_not do |player|
    "Page status should be other than 200"
  end
end
