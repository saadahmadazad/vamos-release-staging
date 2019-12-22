class AddColumnUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :admitted, :boolean, default: false, null: false
  end
end
