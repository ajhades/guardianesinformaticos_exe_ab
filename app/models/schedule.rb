

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

  def free_hours(_week, date)
    total_hours = available_hours
    daily_shifts = DailyShift.where(schedule: self, date:)
    daily_shifts.map do |daily|
      total_hours -= daily.used_hours
    end
    total_hours
  end

  def select_best_range(available_users)
    # Encuentra el objeto con el arreglo más grande
    best_range = available_users.max_by { |obj| obj.values.flatten.size }
    best_range.each_value(&:sort!)
  end

  def define_day(user_id, _schedule, week, date)
    _schedule.map do |value|
      ActiveRecord::Base.transaction do
        day = DailyShift.create!(schedule: self, week:, date:,
                                 start_time: value.first, end_time: value.last, user_id:)
        day.last_modification = Time.now
        day.save
      rescue ActiveRecord::RecordInvalid
        nil
      end
    end
  end

  def free_users_hours_for_day(week, date)
    # Valida que hayan horas aun disponibles para esta tarea
    free_hours_schedule = free_hours(week, date)
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
      temp_daily_shift << { usr.id => availabilities_hours }
    end
    temp_daily_shift
  end

  def assign_users_by_day(week, year)
    day_of_week = DateUtils.get_week_days(week, year)
    day_of_week.map do |day|
      next if free_hours(week, day).blank?

      users_to_schedule = free_users_hours_for_day(week, day)
      next if users_to_schedule.blank?

      user_to_schedule = select_best_range(users_to_schedule)
      user_id = user_to_schedule.keys.first
      user_to_schedule.values.flat_map do |hours|
        define_day(user_id, hours, week, day)
      end
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
