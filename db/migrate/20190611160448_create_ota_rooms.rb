class CreateOtaRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :ota_rooms do |t|
      t.string :uid
      t.integer :status
      t.references :ota, foreign_key: true
      t.references :room, foreign_key: true

      t.timestamps
    end
  end
end
