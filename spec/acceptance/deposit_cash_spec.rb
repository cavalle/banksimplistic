require File.dirname(__FILE__) + '/acceptance_helper'

feature "Deposit cash", %q{
  In order to have money to lend to other clients
  As a banker
  I want clients to deposit cash in their accounts
} do
  
  background do
    @account = open_account
  end
  
  scenario "First cash deposit" do
    visit account_page(@account)

    page.should have_content "Balance: $0"
    
    within_section("Deposit Cash") do
      fill_in "Amount", :with => "100"
      click "Deposit"
    end

    page.should have_content "Balance: $100"
  end
  
  scenario "Second deposit" do
    deposit_cash(:account => @account, :amount => 100)
    deposit_cash(:account => @account, :amount => 100)
    
    visit account_page(@account)
    
    page.should have_content "Balance: $200"
  end
  
end