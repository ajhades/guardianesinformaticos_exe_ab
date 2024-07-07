class CreateSchedules < ActiveRecord::Migration[7.1]
  def change
    create_table :schedules do |t|
      t.integer :day_of_week
      t.string :start_time
      t.string :end_time

      t.timestamps
    end
  end
end
