class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.string :name
      t.integer :stock_max
      t.integer :overbooking_thresh
      t.integer :price
      t.integer :status
      t.references :facility, foreign_key: true

      t.timestamps
    end
  end
end
