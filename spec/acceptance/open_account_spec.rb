require File.dirname(__FILE__) + '/acceptance_helper'

feature "Feature name", %q{
  In order to do evil thing with their money
  As a banker
  I want clients to open accounts
} do
  
  scenario "Client opens a new account" do
    client = create_client(:name => "Ruthie Henshall")
    
    visit client_page(client)
    click_link "Create new account"
    
    fill_in "Name", :with => "Personal Expenses"
    click "Create account!"

    page.should be_success
    page.should have_content("Personal Expenses")
  end
  
end