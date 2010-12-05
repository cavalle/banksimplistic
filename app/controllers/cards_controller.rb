class CardsController < ApplicationController
  def new
    @client = ClientDetailsReport.find(:uid => params[:client_id]).first
  end
  
  def create
    execute_command :assign_new_bank_card, params[:client_id], params[:card][:account]
    redirect_to client_path(params[:client_id])
  end

  def destroy
    execute_command :cancel_bank_card, params[:client_id], params[:id]
    redirect_to client_path(params[:client_id])
  end
end
