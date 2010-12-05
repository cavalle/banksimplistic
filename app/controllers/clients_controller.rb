class ClientsController < ApplicationController
  def index
    @clients = ClientReport.all
  end
  
  def show
    @client = ClientDetailsReport.find(:uid => params[:id]).first
  end

  def edit
    @client = ClientDetailsReport.find(:uid => params[:id]).first
  end
  
  def create
    execute_command :create_client, params[:client]
    redirect_to clients_path
  end

  def name
    execute_command :change_client_name, params[:id], params[:client]
    redirect_to client_path(params[:id])
  end
end
