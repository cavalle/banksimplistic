require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Cancel Bank Card", %q{
  In order to avoid maintenance costs
  As a banker
  I want to cancel client's bank cards no longer needed 
} do

  scenario "Client cancels bank cart" do
    client  = create_client
    account = open_account(:name => "Expenses", :client => client)
    card    = assign_card(:client => client, :account => account)

    visit client_page(client)
    
    within_section("Cancelled Cards") do
      page.should have_no_content("Expenses")
    end

    within_section("Bank Cards") do
      page.should have_content("Expenses")

      click_link "Cancel this card"
    end

    within_section("Cancelled Cards") do
      page.should have_content("Expenses")
    end

    within_section("Bank Cards") do
      page.should have_no_content("Expenses")
    end
  end
end
