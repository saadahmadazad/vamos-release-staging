class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.string :target_type
      t.integer :target_id
      t.string :type
      t.integer :status
      t.string :url
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
