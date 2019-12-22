class RemoveOtaFromOtaRoom < ActiveRecord::Migration[5.2]
  def change
    remove_reference :ota_rooms, :ota, foreign_key: true
  end
end
