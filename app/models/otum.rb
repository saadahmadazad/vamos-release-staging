class Otum < ApplicationRecord
  belongs_to :facility
  has_many :ota_rooms, :dependent => :destroy
  has_many :bookings, through: :ota_rooms
  has_one  :user, through: :facility

  validates :provider, presence: true
  validates :status, presence: true
  validates :account, presence: true
  validates :password, presence: true
  validates :facility_id, presence: true

  enum status: [:init, :sync, :active, :disactive, :error], _suffix: true
  enum crowl_status: [:init, :success, :warning, :error], _suffix: true

  before_validation :set_defaults

  def set_defaults
    # Status
    if self.status.blank?
      self.status = :init
    end
  end

  def encrypt_password(pw)
    encryptor = ::ActiveSupport::MessageEncryptor.new(ENV['OTA_SECRET'], cipher: 'aes-256-cbc')
    encryptor.encrypt_and_sign(pw)
  end

  def set_encrypt_password(pw)
    encryptor = ::ActiveSupport::MessageEncryptor.new(ENV['OTA_SECRET'], cipher: 'aes-256-cbc')
    self.password = encryptor.encrypt_and_sign(pw)
  end

  def decrypt_password
    encryptor = ::ActiveSupport::MessageEncryptor.new(ENV['OTA_SECRET'], cipher: 'aes-256-cbc')
    encryptor.decrypt_and_verify(self.password)
  end

  def set_decrypt_password
    encryptor = ::ActiveSupport::MessageEncryptor.new(ENV['OTA_SECRET'], cipher: 'aes-256-cbc')
    self.password = encryptor.decrypt_and_verify(self.password)
  end
end
