ActionController::Routing::Routes.draw do |map|
  map.resources :clients do |clients|
    clients.resources :accounts
    clients.resources :cards
  end
  map.resources :accounts do |accounts|
    accounts.resources :deposits
  end
end
