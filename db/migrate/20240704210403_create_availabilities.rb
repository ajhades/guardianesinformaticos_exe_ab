class CreateAvailabilities < ActiveRecord::Migration[7.1]
  def change
    create_table :availabilities do |t|
      t.string :day_of_week
      t.string :week
      t.date :date
      t.string :time

      t.timestamps
    end
  end
end
