class TransfersController < ApplicationController
  def create
    execute_command :send_money_transfer, params[:account_id], params[:transfer]
    redirect_to account_path(params[:account_id])
  end
end
