ActionController::Routing::Routes.draw do |map|
  map.resources :clients do |clients|
    clients.resources :accounts
  end
end
