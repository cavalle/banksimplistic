class DepositsController < ApplicationController
  def create
    execute_command :deposit_cash, params[:account_id], params[:deposit]
    redirect_to account_path(params[:account_id])
  end
end
