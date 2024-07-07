class Availability < ApplicationRecord
    belongs_to :user
    validate :unique_availability

    private

    def unique_availability
        if Availability.where(day_of_week: day_of_week, time: time, week: week, date: date).exists?
        errors.add(:base, "there is already one")
        end
    end
end
