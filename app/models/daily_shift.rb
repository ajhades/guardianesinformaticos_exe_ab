

class DailyShift < ApplicationRecord
  belongs_to :schedule
  belongs_to :user
  validates :week, presence: true
  validates :date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :user_id, presence: true
  validates :schedule_id, presence: true
  validate :start_time_before_end_time

  def used_hours
    TimeRangeFormatter.convert_to_hour_array(start_time, end_time)
  end

  private

  def start_time_before_end_time
    if start_time.blank?
      errors.add(:start_time, 'should not be null')
    elsif end_time.blank?
      errors.add(:end_time, 'should not be null')
    elsif start_time > end_time
      errors.add(:start_time, 'must be before end_time')
    end
  end
end
