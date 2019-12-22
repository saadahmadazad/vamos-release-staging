class RemovePriceFromRoom < ActiveRecord::Migration[5.2]
  def change
    remove_column :rooms, :price, :integer
  end
end
