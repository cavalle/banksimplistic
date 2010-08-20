class AccountsController < ApplicationController
  
  def create
    execute_command :open_account, params.slice(:client_id, :account)
    redirect_to client_path(params[:client_id])
  end
  
end
