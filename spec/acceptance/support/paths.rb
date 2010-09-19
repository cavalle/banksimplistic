module NavigationHelpers
  def homepage
    "/"
  end
  
  def clients_page
    "/clients"
  end
  
  def client_page(client)
    "#{clients_page}/#{client.uid}"
  end
  
  def account_page(account)
    "/accounts/#{account.uid}"
  end
end

RSpec.configuration.include NavigationHelpers, :type => :acceptance
