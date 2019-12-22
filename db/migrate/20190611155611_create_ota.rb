class CreateOta < ActiveRecord::Migration[5.2]
  def change
    create_table :ota do |t|
      t.string :provider
      t.integer :status
      t.string :account
      t.string :password
      t.string :token
      t.datetime :last_crawl_at
      t.integer :crowl_status
      t.string :name
      t.references :facility, foreign_key: true

      t.timestamps
    end
  end
end
