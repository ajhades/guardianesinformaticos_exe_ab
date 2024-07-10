class AddAvailabilityToUser < ActiveRecord::Migration[7.1]
  def change
    add_reference :availabilities, :user, foreign_key: true
  end
end
