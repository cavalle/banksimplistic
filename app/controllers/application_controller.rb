class ApplicationController < ActionController::Base
  include CommandBus
  
  around_filter :domain_uow
  
  def domain_uow
    DomainRepository.begin
    yield
    DomainRepository.commit
  end
  
  
  # Force autoloading of Event Subscribers:
  # TODO: Move this to somewhere else or make automatically
  ClientReport; ClientDetailsReport; AccountDetailsReport
  
  protect_from_forgery
end
