class AddScheduleToService < ActiveRecord::Migration[7.1]
  def change
    add_reference :schedules, :service, foreign_key: true
  end
end
