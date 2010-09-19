class ClientsController < ApplicationController
  def index
    @clients = ClientReport.all
  end
  
  def show
    @client = ClientDetailsReport.find(:uid => params[:id])[0]
  end
  
  def create
    execute_command :create_client, params[:client]
    redirect_to clients_path
  end
end
