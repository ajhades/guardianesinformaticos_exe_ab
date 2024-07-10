class AddScheduleToDailyShift < ActiveRecord::Migration[7.1]
  def change
    add_reference :daily_shifts, :schedule, foreign_key: true
  end
end
