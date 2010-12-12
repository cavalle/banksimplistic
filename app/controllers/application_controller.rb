class ApplicationController < ActionController::Base
  include CommandBus
  
  protect_from_forgery
end
