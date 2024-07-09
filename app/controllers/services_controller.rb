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

  # Endpoint para programar la semana
  def schedule_week
    service = Service.find(paras[:id])

    json_response_error('Información incompleta', :bad_request) unless params.key?("week") || params.key?("year")

    service.assign_weekly_schedule(params[:week], params[:year])
    json_response('Programado')
  end

  # Endpoint listar el total de horas utilizadas por cada usuario
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

  # Endpoint para crear esquema de horas utilizadas por cada dia de la semana
  def used_hours_per_user
    week = params[:week].to_i
    date = params[:date]
    output = @service.used_hours_per_user(week, date)
    json_response(output)
  end

  # Endpoint para crear esquema de horas disponibles por cada dia de la semana
  def available_hours_per_user
    week = params[:week].to_i
    date = params[:date]
    output = @service.available_hours_per_user(week, date)
    json_response(output)
  end

  # Horas disponibles por cada dia de la semana
  def availabilities_hours
    output = @service.availabilities_hours
    json_response(output)
  end

  # Fechas para la semana seleccionada
  def week_selected
    date = params[:date]

    begin
      week_range = DateUtils.get_week_range(date)
      week = DateUtils.week_formatted(date)
      output = {
        week: week,
        dates: week_range
      }
      json_response(output)
      rescue ArgumentError
        json_response_error('Formato de fecha incorrecta')
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
