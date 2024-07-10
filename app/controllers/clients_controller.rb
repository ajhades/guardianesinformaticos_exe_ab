class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :update, :destroy]
  def index
    @clients = Client.all
    json_response(@clients)
  end

  def create
    @client = Client.new(client_params)

    if @client.save
      json_response(@client, :created)
    else
      json_response_error(@client.errors, :unprocessable_entity)
    end
  end

  def destroy
    @client.destroy
    head :no_content
  end

  def show
    json_response(@client)
  end

  def update
    if @client.update(client_params)
      json_response(@client)
    else
      json_response_error(@client.errors, :unprocessable_entity)
    end
  end

  private

  def set_client
    @client = Client.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Client not found" }, status: :not_found
  end
  def client_params
    params.require(:client).permit(:name, :nit, :status)
  end

  def json_response(object, status = :ok)
    render json: object, status: status
  end
  def json_response_error(errors, status = :unprocessable_entity)
    render json: { errors: errors }, status: status
  end
end
