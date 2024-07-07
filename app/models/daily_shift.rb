class DailyShift < ApplicationRecord
    # u = User.first
    # t = Service.first
    # crono = t.schedules[0]
    # usuarios = crono.service.users
    # arr =[]
    # usuarios.each { |i| arr << {i.id => i.daily_availability(crono, 2, '2024')}}
    # arr
    # 2024-06-17

    belongs_to :schedule
    belongs_to :user

    def used_hours
        TimeRangeFormatter.convert_to_hour_array(self.start_time, self.end_time)
    end

end
