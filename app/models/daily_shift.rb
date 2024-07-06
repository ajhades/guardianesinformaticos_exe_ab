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
        # date = Date.parse(date)
        temp_daily_shift = []
        users = schedule.service.users
        users.each do |usr| 
            byebug
            # Obtiene disponibilidad para cada usuario
            free_hours = usr.free_hours(schedule, week, date)
            next if free_hours.blank?
            availabilities_hours = TimeRangeFormatter.order_hours(free_hours)
            temp_daily_shift << {usr.id => availabilities_hours}
        end

        ## VALIDAR QUE LA TAREA YA NO TENGA ALGUIEN ASIGNADO

        # Encuentra el objeto con el arreglo más grande
        best_range = temp_daily_shift.max_by { |obj| obj.values.flatten.size }
        best_range.each do |key, values|
            values.sort!
        end
        byebug
        best_range.values.first.each do |value|
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

    def user_busy(user, schedule, week, date)
        # Horas asignadas al usuario
        day = DailyShift.find_by(schedule: schedule, user: user, week: week, date: date)
        # Rango de horas laborales diaria de la tarea 
        # range_hour_schedule = TimeRangeFormatter.convert_to_hour_array(schedule.start_time, schedule.end_time)
        # Rango de horas empleadas por el usuario en esta tarea
        # range_hour_daily = TimeRangeFormatter.convert_to_hour_array(day.start_time, day.end_time)
    end

    def schedule_available(user, schedule, week, date)
        # verificar que la tarea este asignada
        TimeRangeFormatter.convert_to_hour_array(schedule.start_time, schedule.end_time)
        TimeRangeFormatter.convert_to_hour_array(day.start_time, day.end_time)
    end

    def free_hours_user(availabilities_hours)
        availabilities_hours.each do |range|
            range_hour_schedule - range 
        end
    end

end
