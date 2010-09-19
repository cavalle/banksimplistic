require File.dirname(__FILE__) + '/acceptance_helper'

feature "Feature name", %q{
  In order to do evil thing with their money
  As a banker
  I want clients to open accounts
} do
  
  scenario "Client opens a new account" do
    client = create_client(:name => "Ruthie Henshall")
    
    visit client_page(client)
    click_link "Open new account"
    
    fill_in "Name", :with => "Personal Expenses"
    click_button "Open account!"

    within_section("Accounts") do
      page.should have_content("Personal Expenses")
    end
  end
  
  scenario "Accessing accounts from client page" do
    client = create_client(:name => "Ruthie Henshall")
    account = open_account(:client => client, :name => "Expenses")
    
    visit client_page(client)
    
    within_section("Accounts") do
      page.should have_link(:to => account_page(account))
    end
  end
  
end