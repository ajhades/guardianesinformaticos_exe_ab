class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :update, :destroy]
  def index
    @services = Service.all
    json_response(@services)
  end

  def create
    @service = Service.new(service_params)

    if @service.save
      json_response(@service, :created)
    else
      json_response_error(@service.errors, :unprocessable_entity)
    end
  end

  def destroy
    @service.destroy
    head :no_content
  end

  def show
    json_response(@service)
  end

  def update
    if @service.update(service_params)
      json_response(@service)
    else
      json_response_error(@service.errors, :unprocessable_entity)
    end
  end

  private

  def set_service
    @service = Service.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Service not found" }, status: :not_found
  end
  def service_params
    params.require(:service).permit(:name, :start_date, :end_date, :status, :client_id)
  end

  def json_response(object, status = :ok)
    render json: object, status: status
  end
  def json_response_error(errors, status = :unprocessable_entity)
    render json: { errors: errors }, status: status
  end
end
