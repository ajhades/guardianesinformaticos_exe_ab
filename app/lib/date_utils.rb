module DateUtils
    def self.current_week_number
        Date.today.cweek
    end

    # Dias de la semana
    # @param week [Integer]
    # @param year [Integer]
    # @param default [Boolean]
    # @return [Array] - Devuelve arreglo con cada dia de la semana
    def self.get_week_days(week, year, default = true)
        raise ArgumentError, 'Week number must be between 1 and 53' unless (1..53).include?(week)
        raise ArgumentError, 'The year must be a positive number' unless year > 0
        start_date = Date.commercial(year.to_i, week.to_i).beginning_of_week 
        week_days = []
      
        (1..7).each do |day_number|
          week_days << I18n.l(start_date + (day_number - 1).days)  if default
          week_days << I18n.l(start_date + (day_number - 1).days , format: "%A, %d de %B de %Y") unless default
        end
      
        week_days
    end

    # Semana en formato "Semana %V del %Y"
    # @param date [String] - formato "%Y-%m-%d"
    # @return [Date] - Semana en formato semanal
    def self.week_formatted(date)
        raise ArgumentError, 'Date: Incorrect format' unless valid_date?(date)
        I18n.l(Date.parse(date), format: :weekly)
    end

    # Semana en formato "%e de %B de %Y"
    # @param date [String] - formato "%Y-%m-%d"
    # @return [Date] - Fecha en formato extendido
    def self.day_formatted(date)
        raise ArgumentError, 'Date: Incorrect format' unless valid_date?(date)
        I18n.l(Date.parse(date), format: :long)
    end

    # Dia inicial y final de la semana en formato "%d/%m/%Y"
    # @param date [String] - formato "%Y-%m-%d"
    # @return [Object] - { start_date, end_date }
    def self.get_week_range(date)
        raise ArgumentError, 'Date: Incorrect format' unless valid_date?(date)
        start_date = Date.parse(date).beginning_of_week
      
        end_date = start_date + 6.days
      
        { start_date: I18n.l(start_date, format: :alternative), end_date: I18n.l(end_date, format: :alternative) }
    end

    # Fecha exacta segun el dia, semana y año
    # @param day [Integer] - Entre 1-31
    # @param week [Integer] - Entre 1-53
    # @param year [Integer] - Mayor a 0
    # @return [Date]
    def self.get_date_by_week(day, week, year)
        raise ArgumentError, 'Week number must be between 1 and 53' unless (1..53).include?(week)
        raise ArgumentError, 'The Day must be between 1 and 31' unless (1..31).include?(day)
        raise ArgumentError, 'The year must be a positive number' unless year > 0
        I18n.l(Date.commercial(year, week, day))
    end

    # Valida el formato de la fecha 
    # @param date [String] - Fecha a validar
    # @return [Boolean]
    def self.valid_date?(date)
        return true if date == 'never'
      
        !!(date.match(/\d{4}-\d{2}-\d{2}/) && Date.strptime(date, '%Y-%m-%d'))
    rescue ArgumentError
        false
    end
end