class Schedule < ApplicationRecord
    has_many :daily_shifts
    belongs_to :service
    validate :start_time_before_end_time

    private

    def start_time_before_end_time
        if start_time >= end_time
        errors.add(:start_time, "must be before end time")
        end
    end
end
