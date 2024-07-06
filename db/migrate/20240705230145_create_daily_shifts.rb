class CreateDailyShifts < ActiveRecord::Migration[7.1]
  def change
    create_table :daily_shifts do |t|
      t.string :week
      t.date :date
      t.string :start_time
      t.string :end_time
      t.datetime :last_modification

      t.timestamps
    end
  end
end
