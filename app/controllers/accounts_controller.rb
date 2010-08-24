class AccountsController < ApplicationController
  
  def create
    execute_command :open_account, params[:client_id], params[:account]
    redirect_to client_path(params[:client_id])
  end
  
end
