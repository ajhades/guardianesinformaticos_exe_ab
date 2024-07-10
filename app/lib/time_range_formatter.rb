module TimeRangeFormatter
  # Genera arreglo con todas las horas entre el rango ingresado
  # El formato utilizado es "%H:%M"
  # @param start_time [String]
  # @param end_time [String]
  # @return [Array]
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

  # Ordena de menor a mayor las horas ingresadas
  # Y las agrupa en sub arreglos por continuidad 
  # El formato de salida es "%H:%00"
  # @param hours [Array]
  # @return [Array]
  def self.order_hours(hours)
    hours = hours.map { |h| Time.parse(h) }    
    hours.sort!
    
    groups = []
    current_group = [hours.first]
    hours.each_cons(2) do |current, next_hour|
      if next_hour.hour == current.hour + 1
        current_group << next_hour
      else
        groups << current_group
        current_group = [next_hour]
      end
    end
    
    groups << current_group unless current_group.empty? || current_group.all?(&:nil?)
    groups.map { |grupo| grupo.map { |hour| I18n.l(hour, format: :exact_hours) } }
  end
end