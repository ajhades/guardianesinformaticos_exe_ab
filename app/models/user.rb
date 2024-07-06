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

  def daily_availability(schedule, week, year)
    self.availabilities.where(day_of_week: schedule.day_of_week, week: week)
                      .where('extract(year from date) = ?', year)
                      .where("time >= ? and time <= ?", schedule.start_time, schedule.end_time)
                      .pluck(:time).uniq   
  end
end
