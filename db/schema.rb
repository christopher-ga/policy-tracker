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

ActiveRecord::Schema[7.1].define(version: 2024_10_07_194113) do
  create_table "bill_sponsors", force: :cascade do |t|
    t.integer "bill_id", null: false
    t.integer "sponsor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bill_id"], name: "index_bill_sponsors_on_bill_id"
    t.index ["sponsor_id"], name: "index_bill_sponsors_on_sponsor_id"
  end

  create_table "bills", force: :cascade do |t|
    t.string "title"
    t.string "bill_id"
    t.datetime "introduced_date", null: false
    t.datetime "update_date", null: false
    t.string "congress"
    t.string "bill_type"
    t.string "bill_url"
    t.string "latest_action"
    t.string "sponsor_first_name"
    t.string "sponsor_last_name"
    t.string "sponsor_party"
    t.string "sponsor_state"
    t.text "sponsor_url"
  end

  create_table "saved_bills", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "bill_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bill_id"], name: "index_saved_bills_on_bill_id"
    t.index ["user_id"], name: "index_saved_bills_on_user_id"
  end

  create_table "sponsors", force: :cascade do |t|
    t.string "first_name"
    t.string "party"
    t.string "state"
    t.string "last_name"
    t.string "member_type"
    t.string "bioguide_id"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_title"
  end

  create_table "user_saved_bills", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "bill_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bill_id"], name: "index_user_saved_bills_on_bill_id"
    t.index ["user_id"], name: "index_user_saved_bills_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "bill_sponsors", "bills"
  add_foreign_key "bill_sponsors", "sponsors"
  add_foreign_key "saved_bills", "bills"
  add_foreign_key "saved_bills", "users"
  add_foreign_key "user_saved_bills", "bills"
  add_foreign_key "user_saved_bills", "users"
end
