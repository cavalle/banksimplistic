class ApplicationController < ActionController::Base
  include CommandBus
  
  # Force autoloading of Event Subscribers:
  # TODO: Move this to somewhere else or make automatically
  ClientReport; ClientDetailsReport; AccountDetailsReport
  
  protect_from_forgery
end
