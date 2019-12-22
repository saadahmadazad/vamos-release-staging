class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notificatable, polymorphic: true

  validates :target_type, presence: true
  validates :target_id, presence: true
  validates :profile, presence: true
  validates :status, presence: true
  validates :url, presence: true
  validates :user_id, presence: true

  enum status: [:unread, :read], _suffix: true

  before_validation :set_defaults

  def set_defaults
    if self.status.nil?
      self.status = :unread
    end
  end

end
