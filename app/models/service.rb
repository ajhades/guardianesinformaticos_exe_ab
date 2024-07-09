# frozen_string_literal: true

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

  def available_days
    schedules.pluck(:day_of_week).uniq
    # days.map { |day| I18n.t("activerecord.attributes.schedule.day_of_week.#{day}") }
  end
end
