require File.dirname(__FILE__) + '/acceptance_helper'

feature "Change Client Name", %q{
  In order to keep correct information about my clients
  As a banker
  I want to change client's name
} do

  scenario "Client name is changes" do
    client = create_client(:name => "Ruthie Henshall")

    visit client_page(client)
    click_link "Edit client info"

    fill_in "Name", :with => "Ruthie Harrington"
    click_button "Change name"

    page.should be_success
    page.should have_no_content("Ruthie Henshall")
    page.should have_content("Ruthie Harrington")

    visit clients_page

    page.should have_no_content("Ruthie Henshall")
    page.should have_content("Ruthie Harrington")
  end
end
