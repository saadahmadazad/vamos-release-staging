class Booking < ApplicationRecord
  belongs_to :ota_room
  has_one :scraping_log
  has_one :otum, through: :ota_room
  has_one :room, through: :ota_room

  validates :uid, presence: true
  validates :status, presence: true
  validates :checkin, presence: true
  validates :checkout, presence: true
  validates :count_room, presence: true

  # is_block=trueのときは以下をスルー
  with_options unless: :is_blocked? do
    validates :price, presence: true
    validates :price_balance, presence: true
    validates :price_total, presence: true
    validates :subscriber_name, presence: true, allow_blank: true
    validates :guest_name, presence: true
    validates :number_total, presence: true,
              numericality: {
                only_integer: true,
                greater_than: 0
              }
  end

  # enum
  enum status: [:active, :canceled], _suffix: true

  before_validation :set_defaults

  def set_defaults
    if self.price.blank?
      self.price = 0.0
    end
    # 金額
    if self.price_balance.blank?
      self.price_balance = 0.0
    end
    self.price_total = self.price + self.price_balance
    # 通貨
    if self.currency.blank?
      self.currency = 'yen-ja'
    end

    # 宿泊者情報
    if self.guest_name.blank?
      self.guest_name = self.subscriber_name
    end

    # 予約日
    if self.booking_date.blank?
      self.booking_date = Time.now
    end

    # uid
    if self.uid.blank?
      self.uid = SecureRandom.base64(32)
    end

    # uid
    if self.count_room.blank?
      self.count_room = 1
    end
  end

  def blocked?
    user = self.otum.user
    user.all_bookings.blocked_during(self.checkin, self.checkout).exists?
  end

end
