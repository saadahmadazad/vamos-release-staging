class AddNameToOtaRoom < ActiveRecord::Migration[5.2]
  def change
    add_column :ota_rooms, :name, :string
  end
end
