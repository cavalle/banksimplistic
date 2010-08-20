module NavigationHelpers
  # Put here the helper methods related to the paths of your applications
  
  def homepage
    "/"
  end
  
  def clients_page
    "/clients"
  end
  
  def client_page(client)
    "#{clients_page}/#{client.uid}"
  end
end

Spec::Runner.configuration.include(NavigationHelpers)
