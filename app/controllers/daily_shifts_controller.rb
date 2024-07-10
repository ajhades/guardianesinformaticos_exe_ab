class DailyShiftsController < ApplicationController
  before_action :set_daily_shift, only: [:show, :update, :destroy]
  def index
    @daily_shifts = DailyShift.all
    json_response(@daily_shifts)
  end

  def create
    @daily_shift = DailyShift.new(daily_shift_params)

    if @daily_shift.save
      json_response(@daily_shift, :created)
    else
      json_response_error(@daily_shift.errors, :unprocessable_entity)
    end
  end

  def destroy
    @daily_shift.destroy
    head :no_content
  end

  def show
    json_response(@daily_shift)
  end

  def update
    if @daily_shift.update(daily_shift_params)
      json_response(@daily_shift)
    else
      json_response_error(@daily_shift.errors, :unprocessable_entity)
    end
  end

  private

  def set_daily_shift
    @daily_shift = DailyShift.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "DailyShift not found" }, status: :not_found
  end
  def daily_shift_params
    params.require(:daily_shift).permit(:week, :date, :start_time, :end_time, :last_modification, :user_id, :schedule_id)
  end

  def json_response(object, status = :ok)
    render json: object, status: status
  end
  def json_response_error(errors, status = :unprocessable_entity)
    render json: { errors: errors }, status: status
  end
end
