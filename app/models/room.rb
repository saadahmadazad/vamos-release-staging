class Room < ApplicationRecord
  belongs_to :facility
  has_many :ota_rooms, :dependent => :destroy
  has_many :bookings, through: :ota_room
  has_one  :user, through: :facility

  validates :name, presence: true
  validates :stock_max, presence: true,
            numericality: {
              only_integer: true,
              greater_than: 0
            }
  validates :overbooking_thresh, presence: true,
            numericality: {
              only_integer: true,
              greater_than: 0
            }
  validates :status, presence: true
  validates :facility_id, presence: true
  validates :price, presence: true
  validates :currency, presence: true

  enum status: [:active, :inactive], _suffix: true

  before_validation :set_defaults

  def set_defaults
    if self.status.nil?
      # Status
      self.status = :active
    end
    # 通貨
    if self.currency.blank?
      self.currency = 'yen-ja'
    end
  end
end
