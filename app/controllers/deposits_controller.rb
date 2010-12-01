class DepositsController < ApplicationController
  
  # POST /accounts/23/deposits
  def create
    account = Account.find(params[:account_id])
    account.deposite(params[:deposit][:amount].to_i)
    
    redirect_to account
  end
  
end
