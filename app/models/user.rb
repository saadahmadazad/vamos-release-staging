class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtBlacklist

  has_many :notifications, :dependent => :destroy
  has_many :facilities, :dependent => :destroy
  has_many :ota, through: :facilities
  has_many :rooms, through: :facilities

  validates :email, presence: true
  validates :encrypted_password, presence: true
  validates :name, presence: true

  enum role: [:guest, :user, :admin, :super_admin], _suffix: true
  enum billing_status: [:success, :failure, :expired, :waiting, :trialing], _suffix: true

  before_validation :set_defaults
  after_create :create_stripe_customer
  after_create :create_facility

  def set_defaults
    if self.role.nil?
      self.role = :guest
    end
  end

  def create_facility
    facility = Facility.new({
      name: "施設名を入力して下さい。",
      location: "所在地を入力してください。",
      user_id: self.id
    })
    facility.save
  end

  # ストライプの顧客情報を作成
  def create_stripe_customer
    if self.stripe_uid.nil?
      customer = Stripe::Customer.create(
        :email => self.email,
      )
      self.stripe_uid = customer.id
      self.save
    end
  end

  # すべての予約情報を取得
  def all_bookings
    bookings = Array.new
    self.ota.each do |otum|
      bookings.concat(otum.bookings)
    end
    return bookings
  end

  def get_stripe_customer
    if self.stripe_uid.nil?
      return nil
    end
    Stripe::Customer.retrieve(self.stripe_uid)
  end

  # トークンからカード情報をアップデート
  def update_card_info( token )
    # TODO: error handling
    customer = Stripe::Customer.retrieve(self.stripe_uid)
    customer.source = token # Stripe.jsで変換したトークンを渡すだけ
    customer.save
  end

  # カード情報の取得
  def get_card_id
    if self.stripe_uid.blank?
      return nil
    end
    customer = Stripe::Customer.retrieve(self.stripe_uid)
    if customer.sources.data.blank?
      return nil
    end
    customer.sources.data[0].id
  end

  # カード情報(最後4桁)
  def get_card_last_four
    if self.stripe_uid.blank?
      return nil
    end
    customer = Stripe::Customer.retrieve(self.stripe_uid)
    if customer.sources.data.blank?
      return nil
    end
    customer.sources.data[0].last4
  end

  def update_billing_status
    s = true
    trialing = true

    self.facilities.each do |f|
      f_status = f.get_plan_status
      if f_status != 'active' && f_status != 'trialing'
        s = false
      elsif f_status != 'trialing'
        trialing = false
      end
    end

    if s
      if trialing
        self.billing_status = :trialing
      else
        self.billing_status = :success
      end
    else
      self.billing_status = :failure
    end
    self.save
  end

  # 入会金の支払い
  def add_admission_fee
    unless self.admitted
      session = Stripe::Checkout::Session.create(
        customer: self.stripe_uid,
        payment_method_types: ['card'],
        line_items: [{
          name: 'add_admission_fee',
          amount: 25000,
          currency: 'jpy',
          quantity: 1,
        }],
        success_url: 'https://example.com/success?session_id={CHECKOUT_SESSION_ID}',
        cancel_url: 'https://example.com/cancel',
      )
      return true
    else
      return false
    end
  end
end
