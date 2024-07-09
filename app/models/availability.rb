

class Availability < ApplicationRecord
  belongs_to :user
  validates :day_of_week, presence: true
  validates :week, presence: true
  validates :date, presence: true
  validates :time, presence: true
  validates :user_id, presence: true
  validate :unique_availability
  enum day_of_week: { 'L' => 1, 'M' => 2, 'X' => 3, 'J' => 4, 'V' => 5, 'S' => 6, 'D' => 7 }

  private

  def unique_availability
    return unless Availability.where(day_of_week:, time:, week:, date:).exists?

    errors.add(:base, 'there is already one')
  end
end
