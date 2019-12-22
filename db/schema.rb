# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_21_121045) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.string "uid"
    t.integer "status"
    t.datetime "checkin"
    t.datetime "checkout"
    t.integer "count_room"
    t.float "price"
    t.float "price_balance"
    t.float "price_total"
    t.string "subscriber_name"
    t.string "subscriber_kana"
    t.string "subscriber_tel"
    t.string "subscriber_email"
    t.string "subscriber_address"
    t.datetime "booking_date"
    t.string "guest_name"
    t.string "guest_kana"
    t.string "payment_method"
    t.integer "number_total"
    t.integer "number_males"
    t.integer "number_females"
    t.integer "number_adults"
    t.integer "number_children"
    t.string "currency"
    t.bigint "ota_room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "comment"
    t.boolean "is_blocked", default: false, null: false
    t.index ["ota_room_id"], name: "index_bookings_on_ota_room_id"
  end

  create_table "crawl_logs", force: :cascade do |t|
    t.integer "status"
    t.bigint "ota_room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ota_room_id"], name: "index_crawl_logs_on_ota_room_id"
  end

  create_table "facilities", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.string "stripe_subscription_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_facilities_on_user_id"
  end

  create_table "jwt_blacklists", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.index ["jti"], name: "index_jwt_blacklists_on_jti"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "target_type"
    t.integer "target_id"
    t.string "profile"
    t.integer "status"
    t.string "url"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "ota", force: :cascade do |t|
    t.string "provider"
    t.integer "status"
    t.string "account"
    t.string "password"
    t.string "token"
    t.datetime "last_crawl_at"
    t.integer "crowl_status"
    t.string "name"
    t.bigint "facility_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facility_id"], name: "index_ota_on_facility_id"
  end

  create_table "ota_rooms", force: :cascade do |t|
    t.string "uid"
    t.integer "status"
    t.bigint "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.bigint "otum_id"
    t.index ["otum_id"], name: "index_ota_rooms_on_otum_id"
    t.index ["room_id"], name: "index_ota_rooms_on_room_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.integer "stock_max"
    t.integer "overbooking_thresh"
    t.integer "status"
    t.bigint "facility_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "price"
    t.string "currency"
    t.index ["facility_id"], name: "index_rooms_on_facility_id"
  end

  create_table "scraping_logs", force: :cascade do |t|
    t.integer "status"
    t.string "url"
    t.bigint "crawl_log_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "booking_id"
    t.index ["crawl_log_id"], name: "index_scraping_logs_on_crawl_log_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.datetime "expired_at"
    t.integer "role", null: false
    t.integer "billing_status"
    t.string "stripe_uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stripe_paymentmethod_id"
    t.boolean "admitted", default: false, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bookings", "ota_rooms"
  add_foreign_key "crawl_logs", "ota_rooms"
  add_foreign_key "facilities", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "ota", "facilities"
  add_foreign_key "ota_rooms", "ota"
  add_foreign_key "ota_rooms", "rooms"
  add_foreign_key "rooms", "facilities"
  add_foreign_key "scraping_logs", "crawl_logs"
end
