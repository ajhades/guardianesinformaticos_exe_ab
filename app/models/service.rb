class Service < ApplicationRecord
    has_many :user_services
    has_many :users, through: :user_services
    has_many :schedules
    belongs_to :client

    def assign_weekly_schedule(week, date)
        self.schedules.map do |schedule|
            schedule.assign_user_by_day(week, date)
        end
    end
end
