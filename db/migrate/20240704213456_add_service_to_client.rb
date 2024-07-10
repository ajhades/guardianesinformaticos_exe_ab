class AddServiceToClient < ActiveRecord::Migration[7.1]
  def change
    add_reference :services, :client, foreign_key: true
  end
end
