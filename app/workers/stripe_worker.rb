class StripeWorker
  require 'sidekiq-scheduler'

  # queue_as :rakuten
  include Sidekiq::Worker

  def perform(target, action, args=nil)
  end

  class << self
    # =========================
    # 部屋のストックを変更する
    def createAllUserStripe
      User.all.each do |u|
        u.create_stripe_customer
      end
    end
  end
end
