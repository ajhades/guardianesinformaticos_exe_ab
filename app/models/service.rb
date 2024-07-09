class Service < ApplicationRecord
  has_many :user_services
  has_many :users, through: :user_services
  has_many :schedules
  belongs_to :client
  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :client_id, presence: true

  def assign_weekly_schedule(week, year)
    schedules.map do |schedule|
      schedule.assign_users_by_day(week, year)
    end
  end

  def assigned_user
    users.map(&:full_name)
  end

  def availabilities_hours
    schedules.order(:day_of_week).map do |schedule|
      {
        day: schedule.day_of_week_number,
        hours: schedule.available_hours
      }
    end
  end

  def available_hours_per_user(week, date)
    raise ArgumentError, 'La fecha no esta en formato correcto' unless DateUtils.valid_date?(date)

    date = Date.parse(date)
    schedules.order(:day_of_week).map do |schedule|
      schedule_date = DateUtils.get_date_by_week(schedule.day_of_week_number, week, date.year)
      users_hours = users.map do |user|
        hours_user = user.daily_availability(schedule, week, schedule_date).sort!
        {
          id: user.id,
          name: user.full_name,
          hours: hours_user,
          total: hours_user.count
        }
      end
      {
        day: schedule.day_of_week_number,
        date: DateUtils.day_formatted(schedule_date),
        available_hours: schedule.available_hours,
        users: users_hours
      }
    end
  end

  def used_hours_per_user(week, date)
    raise ArgumentError, 'La fecha no esta en formato correcto' unless DateUtils.valid_date?(date)

    date = Date.parse(date)
    schedules.order(:day_of_week).map do |schedule|
      schedule_date = DateUtils.get_date_by_week(schedule.day_of_week_number, week, date.year)
      users_hours = users.map do |user|
        hours_user = user.used_hours(schedule, week, schedule_date).sort!
        {
          id: user.id,
          name: user.full_name,
          hours: hours_user,
          total: hours_user.count
        }
      end
      {
        day: schedule.day_of_week_number,
        date: DateUtils.day_formatted(schedule_date),
        available_hours: schedule.available_hours,
        users: users_hours
      }
    end
  end

  def available_days
    schedules.pluck(:day_of_week).uniq
    # days.map { |day| I18n.t("activerecord.attributes.schedule.day_of_week.#{day}") }
  end
end
