require File.dirname(__FILE__) + '/acceptance_helper'

feature "Create client", %q{
  In order to start selling other services
  As a banker
  I want to sign up new clients
} do
  
  scenario "New user sign up" do
    visit clients_page
    click_link "New client"

    fill_in "Name", :with => "Bernadette Peters"
    fill_in "Street", :with => "17th Broadway, NY"
    fill_in "Postal code", :with => "10002"
    fill_in "City", :with => "New York City"
    fill_in "Phone number", :with => "212-123-4567"

    click_button "Create client!"
    
    page.should have_content("Bernadette Peters")
    
    click_link "Show"

    page.should be_success
    page.should have_content("Bernadette Peters")
    page.should have_content("17th Broadway, NY")
    page.should have_content("10002")
    page.should have_content("New York City")
    page.should have_content("212-123-4567")
  end
  
end