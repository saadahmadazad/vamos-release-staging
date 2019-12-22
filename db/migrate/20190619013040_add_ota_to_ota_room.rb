class AddOtaToOtaRoom < ActiveRecord::Migration[5.2]
  def change
    add_reference :ota_rooms, :otum, foreign_key: true
  end
end
