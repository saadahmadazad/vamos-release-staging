class AddIsBlockedToBooking < ActiveRecord::Migration[5.2]
  def change
    add_column :bookings, :is_blocked, :boolean, default: false, null: false
  end
end
