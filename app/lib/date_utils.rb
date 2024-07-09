module DateUtils
    def self.current_week_number
        Date.today.cweek
    end

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

    def self.week_formatted(week, year)
        raise ArgumentError, 'Week number must be between 1 and 53' unless (1..53).include?(week)
        raise ArgumentError, 'The year must be a positive number' unless year > 0
        I18n.l(Date.commercial(year, week), format: :weekly)
    end

    def self.day_formatted(date)
        raise ArgumentError, 'Date: Incorrect format' unless valid_date?(date)
        I18n.l(Date.parse(date), format: :long)
    end
    
    def self.get_week_range(date)
        raise ArgumentError, 'Date: Incorrect format' unless valid_date?(date)
        start_date = Date.parse(date).beginning_of_week
      
        end_date = start_date + 6.days
      
        { start_date: I18n.l(start_date), end_date: I18n.l(end_date) }
    end

    def self.get_date_by_week(day, week, year)
        raise ArgumentError, 'Week number must be between 1 and 53' unless (1..53).include?(week)
        raise ArgumentError, 'The Day must be between 1 and 31' unless (1..31).include?(day)
        raise ArgumentError, 'The year must be a positive number' unless year > 0
        I18n.l(Date.commercial(year, week, day))
    end

    def self.valid_date?(string)
        return true if string == 'never'
      
        !!(string.match(/\d{4}-\d{2}-\d{2}/) && Date.strptime(string, '%Y-%m-%d'))
    rescue ArgumentError
        false
    end
end