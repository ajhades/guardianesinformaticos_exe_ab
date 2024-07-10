class Schedule < ApplicationRecord
  has_many :daily_shifts
  belongs_to :service
  validates :day_of_week, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :service_id, presence: true
  validate :start_time_before_end_time
  enum day_of_week: { 'L' => 1, 'M' => 2, 'X' => 3, 'J' => 4, 'V' => 5, 'S' => 6, 'D' => 7 }
  def available_hours
    TimeRangeFormatter.convert_to_hour_array(start_time, end_time)
  end

  def day_of_week_number
    Schedule.day_of_weeks[day_of_week]
  end

  def free_hours(daily_shifts, current_available_hours)
    total_hours = current_available_hours
    daily_shifts.map do |daily|
      total_hours -= daily.used_hours
    end
    total_hours
  end

  # Encuentra el objeto con el arreglo más grande
  def select_best_range(available_users)
    best_range = available_users.max_by { |obj| obj.values.flatten.size }
    best_range.each_value(&:sort!)
  end

  # Asigna tarea a los usuarios disponibles
  def define_day(user_id, hours, week, date)
    hours.map do |value|
      ActiveRecord::Base.transaction do
        DailyShift.create!(schedule: self, week:, date:,
                           start_time: value.first, end_time: value.last, user_id:)
      rescue ActiveRecord::RecordInvalid
        nil
      end
    end
  end

  # Devuelve horario disponible para cada usuario
  def free_users_hours_for_day(week, date, free_hours_schedule)
    # Valida que hayan horas aun disponibles para esta tarea
    return nil if free_hours_schedule.blank?

    users = service.users
    return nil if users.blank?

    temp_daily_shift = []
    users.each do |usr|
      # Obtiene disponibilidad para cada usuario
      free_hours_usr = usr.free_hours(self, week, date)
      next if free_hours_usr.blank?

      free_hours_usr = free_hours_usr.intersection(free_hours_schedule)
      availabilities_hours = TimeRangeFormatter.order_hours(free_hours_usr)
      next if availabilities_hours.blank?

      temp_daily_shift << { usr.id => availabilities_hours }
    end
    temp_daily_shift
  end

  # Obtiene horario disponible de la tarea y asigna usuario con disponibilidad
  def assign_users_by_day(week, date)
    year = Date.parse(date).year
    day_of_week = DateUtils.get_week_days(week, year)
    current_available_hours = available_hours

    all_daily_shifts = DailyShift.where(schedule: self, date: day_of_week).group_by { |shift| shift.date.strftime('%Y-%m-%d') }

    day_of_week.map do |day|
      daily_shifts = all_daily_shifts[day] || []

      daily_shifts_saved = []
      # Loop para garantizar que se asignen todos los usuarios posibles a este dia
      loop do
        current_free_hours = free_hours(daily_shifts, current_available_hours)
        break if current_free_hours.blank?

        users_to_schedule = free_users_hours_for_day(week, day, current_free_hours)
        break if users_to_schedule.blank?

        # Obtiene el usuario con disponibilidad
        user_to_schedule = select_best_range(users_to_schedule)
        user_id = user_to_schedule.keys.first
        saved = user_to_schedule.values.flat_map do |hours|
          define_day(user_id, hours, week, day)
        end
        if saved.present?
          daily_shifts.push(*saved.compact)
          daily_shifts_saved.push(*saved.compact)
        end
        break unless saved.compact.present?
      end
      daily_shifts_saved
    end
  end

  private

  def start_time_before_end_time
    if start_time.blank?
      errors.add(:start_time, 'should not be null')
    elsif end_time.blank?
      errors.add(:end_time, 'should not be null')
    elsif start_time > end_time
      errors.add(:start_time, 'must be before end time')
    end
  end
end
