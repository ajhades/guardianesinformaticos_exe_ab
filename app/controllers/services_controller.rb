class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :update, :destroy, :total_used_hours_per_user, :availabilities_hours, :available_hours_per_user, :used_hours_per_user]
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

  def schedule_week
    service = Service.find(paras[:id])

    json_response_error('Información incompleta', :bad_request) unless params.key?("week") || params.key?("year")

    service.assign_weekly_schedule(params[:week], params[:year])
    json_response('Programado')
  end

  def total_used_hours_per_user
    week = params[:week]
    date = params[:date]
    users = @service.users
    output = users.map do |user|
      total_hours = user.used_hours_by_week(@service, week, date)
      {
        user: {
          name: user.full_name,
          id: user.id
        },
        hours: total_hours,
        total_hours: total_hours.count
      }
    end

    json_response(output)
  end

  def used_hours_per_user
    week = params[:week].to_i
    date = params[:date]
    output = @service.used_hours_per_user(week, date)
    json_response(output)
  end

  def available_hours_per_user
    week = params[:week].to_i
    date = params[:date]
    output = @service.available_hours_per_user(week, date)
    json_response(output)
  end

  def availabilities_hours
    output = @service.availabilities_hours
    json_response(output)
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
