class User < ApplicationRecord
  has_many :user_services
  has_many :services, through: :user_services
  has_many :availabilities
  has_many :daily_shifts
  belongs_to :client
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # scope :availabilities_hours, ->(day_of_week, week) { where("LENGTH(title) > ?", length) }

  def full_name
    "#{try(:first_name)} #{try(:last_name)}".to_s
  end
  def daily_availability(schedule, week, date)
    raise ArgumentError, 'La fecha no esta en formato correcto' unless DateUtils.valid_date?(date)
    date = Date.parse(date)
    self.availabilities.where(day_of_week: schedule.day_of_week, week: week, date: date.beginning_of_day..date.end_of_day)
                      .where("time >= ? and time <= ?", schedule.start_time, schedule.end_time)
                      .pluck(:time).uniq   
  end
  
  def weekly_availability(week, date)
    raise ArgumentError, 'La fecha no esta en formato correcto' unless DateUtils.valid_date?(date)
    date = Date.parse(date)
    availabilities_hours = Availability.where(user:self, week: week)
                                        .where('extract(year  from date) = ?', date.year)
                                        .pluck(:time)
    availabilities_hours.sort!
  end

  def free_hours(schedule, week, date)
    # Total de horas disponible
    total_daily_hours = daily_availability(schedule, week, date)
    # Horas ocupado
    daily_shifts = DailyShift.where(schedule: schedule, user: self, week: week, date: date)
    return total_daily_hours if daily_shifts.empty?
    daily_shifts.map do |daily_shift|
      # Rango de horas ocupado
      range_hour_daily = TimeRangeFormatter.convert_to_hour_array(daily_shift.start_time, daily_shift.end_time)
      total_daily_hours = total_daily_hours - range_hour_daily
    end
    # Total de horas libres
    total_daily_hours.sort!
  end

  def used_hours(schedule, week, date)
    total_daily_hours = []
    # Horas ocupado
    daily_shifts = DailyShift.where(schedule: schedule, user: self, week: week, date: date)
    return total_daily_hours if daily_shifts.empty?

    daily_shifts.map do |daily_shift|
      # Rango de horas ocupado
      total_daily_hours << TimeRangeFormatter.convert_to_hour_array(daily_shift.start_time, daily_shift.end_time)
    end
    total_daily_hours.flatten
  end

  def used_hours_by_week(service, week, date)
    raise ArgumentError, 'Date: Incorrect format' unless DateUtils.valid_date?(date)
    date = Date.parse(date)
    total_hours = []
    daily_shifts = DailyShift.where(week: week, user: self, schedule: service.schedules.pluck(:id))
                              .where('extract(year  from date) = ?', date.year)
    
    return total_hours if daily_shifts.blank?
    daily_shifts.map do |daily_shift|
      total_hours << TimeRangeFormatter.convert_to_hour_array(daily_shift.start_time, daily_shift.end_time)
    end
    total_hours.flatten.sort!
  end


end
