class CrawlLog < ApplicationRecord
  belongs_to :ota_room

  validates :status, presence: true
  validates :ota_room_id, presence: true

  enum status: [:success, :error], _suffix: true
end
