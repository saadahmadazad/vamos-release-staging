class ScrapingLog < ApplicationRecord
  belongs_to :crawl_log
  has_one :booking

  validates :status, presence: true
  validates :url, presence: true
  validates :crawl_log_id, presence: true

  enum status: [:success, :error, :warning], _suffix: true
end
