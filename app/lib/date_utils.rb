module DateUtils
    def self.current_week_number
        Date.today.cweek
    end

    def self.get_week_days(week, year, default=true)
        raise ArgumentError, 'Número de semana debe estar entre 1 y 53' unless (1..53).include?(week)
        raise ArgumentError, 'El año debe ser un número positivo' unless year > 0
        start_date = Date.commercial(year.to_i, week.to_i).beginning_of_week 
        week_days = []
      
        (1..7).each do |day_number|
          week_days << I18n.l(start_date + (day_number - 1).days)  if default
          week_days << I18n.l(start_date + (day_number - 1).days , format: "%A, %d de %B de %Y") unless default
        end
      
        week_days
    end

    def self.week_formatted(week, year)
        raise ArgumentError, 'Número de semana debe estar entre 1 y 53' unless (1..53).include?(week)
        raise ArgumentError, 'El año debe ser un número positivo' unless year > 0
        I18n.l(Date.commercial(year.to_i, week.to_i), format: :weekly)
    end
    
    def self.get_week_range(date)
        raise ArgumentError, 'La fecha no esta en formato correcto' unless valid_date?(date)
        start_date = Date.parse(date).beginning_of_week
      
        end_date = start_date + 6.days
      
        { start_date: I18n.l(start_date), end_date: I18n.l(end_date) }
    end

    def self.valid_date?(string)
        return true if string == 'never'
      
        !!(string.match(/\d{4}-\d{2}-\d{2}/) && Date.strptime(string, '%Y-%m-%d'))
    rescue ArgumentError
        false
    end
end