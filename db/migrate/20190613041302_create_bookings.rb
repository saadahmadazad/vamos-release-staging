class CreateBookings < ActiveRecord::Migration[5.2]
  def change
    create_table :bookings do |t|
      t.string :uid
      t.integer :status
      t.datetime :checkin
      t.datetime :checkout
      t.integer :count_room
      t.float :price
      t.float :price_balance
      t.float :price_total
      t.string :subscriber_name
      t.string :subscriber_kana
      t.string :subscriber_tel
      t.string :subscriber_email
      t.string :subscriber_address
      t.datetime :booking_date
      t.string :guest_name
      t.string :guest_kana
      t.string :payment_method
      t.integer :number_total
      t.integer :number_males
      t.integer :number_females
      t.integer :number_adults
      t.integer :number_children
      t.string :currency
      t.references :ota_room, foreign_key: true

      t.timestamps
    end
  end
end
