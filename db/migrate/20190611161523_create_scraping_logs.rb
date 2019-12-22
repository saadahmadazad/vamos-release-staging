class CreateScrapingLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :scraping_logs do |t|
      t.integer :status
      t.string :url
      t.references :crawl_log, foreign_key: true

      t.timestamps
    end
  end
end
