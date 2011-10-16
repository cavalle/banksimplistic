Rails.application.class.configure do
  config.to_prepare do 
    # Initialize Eventwire before each request so that using the InProcess driver 
    # in development the event handlers are declared only once
    Eventwire.driver = Rails.env.test? ? 'InProcess' : 'Redis'
    Eventwire.on_error do |ex|
      raise ex
    end
    ClientReport; ClientDetailsReport; AccountDetailsReport; MoneyTransferSaga
  end
end


