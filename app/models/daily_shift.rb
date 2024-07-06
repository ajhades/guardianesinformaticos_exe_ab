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

    def defined_day(schedule, week, date)
        date = Date.parse(date)
        temp_daily_shift = []
        users = schedule.service.users
        users.each do |usr| 
            # Obtiene disponibilidad para cada usuario
            temp_daily_shift << {usr.id => usr.group_range_hours(schedule, week, date.year)}
        end
        byebug
        # Encuentra el objeto con el arreglo más grande
        best_range = temp_daily_shift.max_by { |obj| obj.values.flatten.size }
        best_range.each do |key, values|
            values.sort!
        end
        byebug
        best_range.values.first.each do |value|
            byebug
            day = DailyShift.create(
                schedule: schedule, 
                week: week, 
                date: date, 
                start_time: value.first, 
                end_time: value.last ,
                user_id: best_range.keys.first
                )
            day.last_modification = Time.zone.now
            day.save
        end
    end
end
