require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Send Money Transfer", %q{
  In order for money to circulate  
  As a banker
  I want my clients to send money transfers to other accounts
} do

  before do
    stub_request(:any, /banking-system\.example\.com/)
  end

  scenario "Send money transfer to an internal account" do
    source_account = open_account
    target_account = open_account
    deposit_cash :account => source_account, :amount => 19

    visit account_page(source_account)
    within_section("Money Transfers") do
      fill_in "Target account", :with => target_account.uid
      fill_in "Amount", :with => 19
      click_button "Send money"
    end
    
    a_request(:post, "banking-system.example.com").should_not have_been_made

    page.should have_content "Balance: $0"

    visit account_page(target_account)

    page.should have_content "Balance: $19"
  end

  scenario "Send money transfer to an external account" do
    source_account = open_account
    deposit_cash :account => source_account, :amount => 19
    external_account_number = UUIDTools::UUID.timestamp_create.to_s

    visit account_page(source_account)
    within_section("Money Transfers") do
      fill_in "Target account", :with => external_account_number
      fill_in "Amount", :with => 19
      click_button "Send money"
    end

    a_request(:post, "banking-system.example.com/accounts/#{external_account_number}").
      with(:body => {:from => source_account.uid, :amount => 19}.to_params).
      should have_been_made

    page.should have_content "Balance: $0"
  end

  scenario "Failed money transfer to an external account" do
    source_account = open_account
    deposit_cash :account => source_account, :amount => 19
    external_account_number = UUIDTools::UUID.timestamp_create.to_s

    stub_request(:post, "banking-system.example.com/accounts/#{external_account_number}").
      to_return(:status => 404)

    visit account_page(source_account)
    within_section("Money Transfers") do
      fill_in "Target account", :with => external_account_number
      fill_in "Amount", :with => 19
      click_button "Send money"
    end

    page.should have_content "Balance: $19"
  end
end
