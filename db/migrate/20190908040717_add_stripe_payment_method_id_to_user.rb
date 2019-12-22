class AddStripePaymentMethodIdToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :stripe_paymentmethod_id, :string
  end
end
