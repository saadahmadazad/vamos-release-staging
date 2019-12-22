class AddReferencesToScrapingLog < ActiveRecord::Migration[5.2]
  def change
    add_column :scraping_logs, :booking_id, :integer
  end
end
