class AddColumnsToRoom < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :price, :float
    add_column :rooms, :currency, :string
  end
end
