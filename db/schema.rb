# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_06_23_082115) do
  create_table "booking_seats", force: :cascade do |t|
    t.integer "booking_id", null: false
    t.datetime "created_at", null: false
    t.integer "seat_id", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_booking_seats_on_booking_id"
    t.index ["seat_id"], name: "index_booking_seats_on_seat_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.datetime "booked_at"
    t.string "booking_reference"
    t.integer "booking_status"
    t.datetime "created_at", null: false
    t.integer "payment_status"
    t.integer "show_id", null: false
    t.decimal "total_amount"
    t.integer "total_tickets"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["show_id"], name: "index_bookings_on_show_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "movies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "duration"
    t.string "genre"
    t.string "language"
    t.date "release_date"
    t.integer "status"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.decimal "amount"
    t.integer "booking_id", null: false
    t.datetime "created_at", null: false
    t.string "gateway_name"
    t.datetime "paid_at"
    t.integer "payment_status"
    t.string "transaction_id"
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_payments_on_booking_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.text "comment"
    t.datetime "created_at", null: false
    t.integer "movie_id", null: false
    t.integer "rating"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["movie_id"], name: "index_reviews_on_movie_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "screens", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "screen_type"
    t.integer "status"
    t.integer "theater_id", null: false
    t.integer "total_seats"
    t.datetime "updated_at", null: false
    t.index ["theater_id"], name: "index_screens_on_theater_id"
  end

  create_table "seat_locks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at"
    t.integer "seat_id", null: false
    t.integer "show_id", null: false
    t.integer "status"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["seat_id"], name: "index_seat_locks_on_seat_id"
    t.index ["show_id"], name: "index_seat_locks_on_show_id"
    t.index ["user_id"], name: "index_seat_locks_on_user_id"
  end

  create_table "seats", force: :cascade do |t|
    t.integer "category"
    t.datetime "created_at", null: false
    t.string "row_name"
    t.integer "screen_id", null: false
    t.integer "seat_number"
    t.datetime "updated_at", null: false
    t.index ["screen_id"], name: "index_seats_on_screen_id"
  end

  create_table "shows", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "end_time"
    t.integer "movie_id", null: false
    t.integer "screen_id", null: false
    t.datetime "start_time"
    t.integer "status"
    t.decimal "ticket_price"
    t.datetime "updated_at", null: false
    t.index ["movie_id"], name: "index_shows_on_movie_id"
    t.index ["screen_id"], name: "index_shows_on_screen_id"
  end

  create_table "subscription_plans", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.decimal "price"
    t.integer "status"
    t.integer "theater_limit"
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "end_date"
    t.date "start_date"
    t.integer "status"
    t.integer "subscription_plan_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["subscription_plan_id"], name: "index_subscriptions_on_subscription_plan_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "theaters", force: :cascade do |t|
    t.string "address"
    t.string "city"
    t.string "contact_number"
    t.string "country"
    t.datetime "created_at", null: false
    t.string "description"
    t.string "email"
    t.string "name"
    t.string "state"
    t.integer "status"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_theaters_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role"
    t.integer "status"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "booking_seats", "bookings"
  add_foreign_key "booking_seats", "seats"
  add_foreign_key "bookings", "shows"
  add_foreign_key "bookings", "users"
  add_foreign_key "payments", "bookings"
  add_foreign_key "reviews", "movies"
  add_foreign_key "reviews", "users"
  add_foreign_key "screens", "theaters"
  add_foreign_key "seat_locks", "seats"
  add_foreign_key "seat_locks", "shows"
  add_foreign_key "seat_locks", "users"
  add_foreign_key "seats", "screens"
  add_foreign_key "shows", "movies"
  add_foreign_key "shows", "screens"
  add_foreign_key "subscriptions", "subscription_plans"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "theaters", "users"
end
