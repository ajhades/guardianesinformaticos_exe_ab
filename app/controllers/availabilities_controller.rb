class AvailabilitiesController < ApplicationController
  before_action :set_availability, only: [:show, :update, :destroy]
  def index
    @availabilities = Availability.all
    json_response(@availabilities)
  end

  def create
    @availability = Availability.new(availability_params)

    if @availability.save
      json_response(@availability, :created)
    else
      json_response_error(@availability.errors, :unprocessable_entity)
    end
  end

  def destroy
    @availability.destroy
    head :no_content
  end

  def show
    json_response(@availability)
  end

  def update
    if @availability.update(availability_params)
      json_response(@availability)
    else
      json_response_error(@availability.errors, :unprocessable_entity)
    end
  end

  private

  def set_availability
    @availability = Availability.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Availability not found" }, status: :not_found
  end
  def availability_params
    params.require(:availability).permit(:day_of_week, :week, :date, :time, :user_id)
  end

  def json_response(object, status = :ok)
    render json: object, status: status
  end
  def json_response_error(errors, status = :unprocessable_entity)
    render json: { errors: errors }, status: status
  end
end
