class DailyShift < ApplicationRecord
    belongs_to :schedule
    belongs_to :user

    def used_hours
        TimeRangeFormatter.convert_to_hour_array(self.start_time, self.end_time)
    end

end
