class Schedule < ApplicationRecord
    has_many :daily_shifts
    belongs_to :service
    validate :start_time_before_end_time
    enum day_of_week: {
        "L" => 1,
        "M" => 2,
        "X" => 3,
        "J" => 4,
        "V" => 5,
        "S" => 6,
        "D" => 7
    }    
    def available_hours
        TimeRangeFormatter.convert_to_hour_array(self.start_time, self.end_time)
    end

    def free_hours(week, date)
        total_hours = self.available_hours
        daily_shifts = DailyShift.where(schedule: self, date: date)
        daily_shifts.map do |daily|
            total_hours = total_hours - daily.used_hours
        end
        total_hours
    end

    def define_day(week, date)
        free_users_hours = free_users_hours_for_day(week, date)
        return nil if free_users_hours.blank?

        # Encuentra el objeto con el arreglo más grande
        best_range = free_users_hours.max_by { |obj| obj.values.flatten.size }
        best_range.each do |key, values|
            values.sort!
        end
        best_range.values.first.each do |value|
            day = DailyShift.create(
                schedule: self, 
                week: week, 
                date: date, 
                start_time: value.first, 
                end_time: value.last ,
                user_id: best_range.keys.first
                )
            day.last_modification = Time.now
            day.save
        end
    end

    def free_users_hours_for_day(week, date)
        # Valida que hayan horas aun disponibles para esta tarea
        free_hours_schedule = free_hours(week, date)
        return nil if free_hours_schedule.blank?

        users = self.service.users
        return nil if users.blank?
        
        temp_daily_shift = []
        users.each do |usr| 
            # Obtiene disponibilidad para cada usuario
            free_hours_usr = usr.free_hours(self, week, date)
            next if free_hours_usr.blank?

            free_hours_usr = free_hours_usr.intersection(free_hours_schedule)
            availabilities_hours = TimeRangeFormatter.order_hours(free_hours_usr)
            temp_daily_shift << {usr.id => availabilities_hours}
        end
        temp_daily_shift
    end

    def assign_users_by_day(week, year)
        day_of_week = DateUtils.get_week_days(week, year)
        day_of_week.map do |day|
            next if free_hours(week, day).blank?
            define_day(week, day) until define_day(week, day).blank?
        end
      end

    private

    def start_time_before_end_time
        if start_time >= end_time
        errors.add(:start_time, "must be before end time")
        end
    end
end
