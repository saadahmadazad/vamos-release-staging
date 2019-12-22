class CreateFacilities < ActiveRecord::Migration[5.2]
  def change
    create_table :facilities do |t|
      t.string :name
      t.string :location
      t.string :stripe_subscription_id
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
