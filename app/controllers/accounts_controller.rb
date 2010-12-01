class AccountsController < ApplicationController
  def show
    @account = AccountDetailsReport.find(:uid => params[:id]).first
  end
  
  def create
    execute_command :open_account, params[:client_id], params[:account]
    redirect_to client_path(params[:client_id])
  end
end
