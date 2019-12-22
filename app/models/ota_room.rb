class OtaRoom < ApplicationRecord
  belongs_to :otum
  belongs_to :room
  has_many :crawl_logs, :dependent => :nullify
  has_many :bookings, :dependent => :destroy

  validates :uid, presence: true
  validates :status, presence: true
  validates :otum_id, presence: true

  enum status: [:unlinked, :linked, :lost_link], _suffix: true

  before_validation :set_default

  def set_default
    if self.uid.nil?
      self.uid = SecureRandom.base64(8)
    end
    if self.room.nil?
      self.status = :unlinked
    else
      self.status = :linked
    end
  end
end
