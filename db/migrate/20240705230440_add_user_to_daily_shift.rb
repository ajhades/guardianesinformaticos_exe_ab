class AddUserToDailyShift < ActiveRecord::Migration[7.1]
  def change
    add_reference :daily_shifts, :user, foreign_key: true
  end
end
