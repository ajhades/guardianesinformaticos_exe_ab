module TimeRangeFormatter
  def self.convert_to_hour_array(start_time, end_time)
    start_time = Time.parse(start_time) unless start_time.is_a?(Time)
    end_time = Time.parse(end_time) unless end_time.is_a?(Time)
    
    hours = []
    current_time = start_time

    while current_time <= end_time
      hours << current_time.strftime('%H:%M')
      current_time += 1.hour
    end

    hours
  end

  def self.order_hours(hours)
    # Convertir las horas en objetos Time
    hours = hours.map { |h| Time.parse(h) }
    
    # Ordenar las horas (por si acaso no están ordenadas)
    hours.sort!
    
    # Inicializar las variables para agrupar las horas
    groups = []
    current_group = [hours.first]
    # Recorrer las horas y agrupar las continuas
    hours.each_cons(2) do |current, next_hour|
      if next_hour.hour == current.hour + 1
        current_group << next_hour
      else
        groups << current_group
        current_group = [next_hour]
      end
    end
    
    # Añadir el último grupo
    groups << current_group unless current_group.empty? || current_group.all?(&:nil?)
    # Convertir los objetos Time de vuelta a cadenas
    groups.map { |grupo| grupo.map { |hour| hour.strftime('%H:%M') } }
  end
end