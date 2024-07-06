class User < ApplicationRecord
  has_many :user_services
  has_many :services, through: :user_services
  has_many :availabilities
  has_many :daily_shifts
  belongs_to :client
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # scope :availabilities_hours, ->(day_of_week, week) { where("LENGTH(title) > ?", length) }

  def daily_availability(schedule, week, year)
    self.availabilities.where(day_of_week: schedule.day_of_week, week: week)
                      .where('extract(year from date) = ?', year)
                      .where("time >= ? and time <= ?", schedule.start_time, schedule.end_time)
                      .pluck(:time).uniq   
  end

  def group_range_hours(schedule, week, year)
    # Convertir las horas en objetos Time
    horas = self.daily_availability(schedule, week, year).map { |h| Time.parse(h) }
    
    # Ordenar las horas (por si acaso no están ordenadas)
    horas.sort!
    
    # Inicializar las variables para agrupar las horas
    grupos = []
    grupo_actual = [horas.first]
    
    # Recorrer las horas y agrupar las continuas
    horas.each_cons(2) do |hora_actual, siguiente_hora|
      if siguiente_hora.hour == hora_actual.hour + 1
        grupo_actual << siguiente_hora
      else
        grupos << grupo_actual
        grupo_actual = [siguiente_hora]
      end
    end
    
    # Añadir el último grupo
    grupos << grupo_actual unless grupo_actual.empty?
    
    # Convertir los objetos Time de vuelta a cadenas
    grupos.map { |grupo| grupo.map { |hora| hora.strftime('%H:%M') } }
  end
end
