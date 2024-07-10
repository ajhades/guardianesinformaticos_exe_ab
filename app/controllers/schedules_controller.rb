class SchedulesController < ApplicationController
  before_action :set_schedule, only: [:show, :update, :destroy]
  def index
    @schedules = Schedule.all
    json_response(@schedules)
  end

  def create
    @schedule = Schedule.new(schedule_params)

    if @schedule.save
      json_response(@schedule, :created)
    else
      json_response_error(@schedule.errors, :unprocessable_entity)
    end
  end

  def destroy
    @schedule.destroy
    head :no_content
  end

  def show
    json_response(@schedule)
  end

  def update
    if @schedule.update(schedule_params)
      json_response(@schedule)
    else
      json_response_error(@schedule.errors, :unprocessable_entity)
    end
  end

  private

  def set_schedule
    @schedule = Schedule.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Schedule not found" }, status: :not_found
  end
  def schedule_params
    params.require(:schedule).permit(:day_of_week, :start_time, :end_time, :service_id)
  end

  def json_response(object, status = :ok)
    render json: object, status: status
  end
  def json_response_error(errors, status = :unprocessable_entity)
    render json: { errors: errors }, status: status
  end
end
