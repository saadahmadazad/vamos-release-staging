class Facility < ApplicationRecord
  belongs_to :user
  has_many :rooms, :dependent => :destroy
  has_many :ota, :dependent => :destroy

  validates :user_id, presence: true

  after_create :create_default_ota
  after_create :create_subscription

  def create_default_ota
    otum = Otum.new
    otum.provider = 'default'
    otum.facility_id = self.id
    otum.status = :active
    otum.account = 'default'
    otum.set_encrypt_password('default')
    otum.save
  end

  # 定期購入を作成
  def create_subscription
    user = User.find(self.user_id)

    if self.stripe_subscription_id.blank?
      subscription = Stripe::Subscription.create(
        customer: user.stripe_uid,
        items: [
          {
            plan: 'standard',
          },
        ],
        trial_from_plan: true,
      )
      self.stripe_subscription_id = subscription.id
      self.save
    else
      return false
    end
  end

  # 定期購入情報を取得
  def get_subscription
    if self.stripe_subscription_id.nil?
      return nil
    end
    Stripe::Subscription.retrieve(self.stripe_subscription_id)
  end

  def get_plan_status
    if self.stripe_subscription_id.nil?
      return nil
    end
    subscription = Stripe::Subscription.retrieve(self.stripe_subscription_id)
    return subscription.status
  end

  def update_status
    if self.stripe_subscription_id
      return nil
    end
    Stripe::Subscription.retrieve(self.stripe_subscription_id)
    # TODO: update
  end
end
