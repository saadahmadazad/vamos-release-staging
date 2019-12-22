class CreateCrawlLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :crawl_logs do |t|
      t.integer :status
      t.references :ota_room, foreign_key: true

      t.timestamps
    end
  end
end
