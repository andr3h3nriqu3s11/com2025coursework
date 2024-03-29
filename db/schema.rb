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

ActiveRecord::Schema.define(version: 2021_12_02_213453) do

  create_table "quick_links", force: :cascade do |t|
    t.string "name", null: false
    t.integer "origin_id", null: false
    t.integer "destination_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["destination_id"], name: "index_quick_links_on_destination_id"
    t.index ["origin_id"], name: "index_quick_links_on_origin_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.string "description"
    t.decimal "value", precision: 15
    t.integer "origin_id", null: false
    t.integer "destination_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["destination_id"], name: "index_transactions_on_destination_id"
    t.index ["origin_id"], name: "index_transactions_on_origin_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_type", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wallet_icons", force: :cascade do |t|
    t.string "icon", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["icon"], name: "index_wallet_icons_on_icon", unique: true
  end

  create_table "wallets", force: :cascade do |t|
    t.string "name", null: false
    t.string "color", default: ""
    t.integer "value", default: 0
    t.boolean "system", default: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "wallet_icon_id"
    t.index ["name", "user_id"], name: "index_wallets_on_name_and_user_id", unique: true
    t.index ["user_id"], name: "index_wallets_on_user_id"
    t.index ["wallet_icon_id"], name: "index_wallets_on_wallet_icon_id"
  end

end
