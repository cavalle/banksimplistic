require File.dirname(__FILE__) + '/acceptance_helper'

feature "Assign new bank card", %q{
  In order withdraw money and operate with their accounts from anywhere
  As a banker
  I want clients to have bank cards
} do
  scenario "New card assigned to client" do
    client  = create_client
    account = open_account(:name => "Expenses", :client => client)
    
    visit client_page(client)
    click_link "Assign new card"
    
    select "Expenses", :from => "Account"
    click_button "Assign card!"
    
    visit client_page(client)

    within_section("Bank Cards") do
      page.should have_content("Expenses")
      page.should have_xpath("/./*", :text => /(\d{4} ?){4}/)
    end
  end
  
end
