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

ActiveRecord::Schema[7.0].define(version: 2024_01_02_211620) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "listings", force: :cascade do |t|
    t.string "status", default: "new"
    t.string "ref_number"
    t.string "idfile"
    t.string "idagency"
    t.string "listing_type"
    t.float "latitude"
    t.float "longitude"
    t.string "address"
    t.string "typestreet"
    t.string "namestreet"
    t.string "numberstreet"
    t.string "postcode"
    t.string "speclocation"
    t.string "region"
    t.string "province"
    t.string "country"
    t.float "usable_area"
    t.float "built_area"
    t.string "operation"
    t.decimal "salesprice"
    t.decimal "rentprice"
    t.string "title_ca"
    t.string "title_es"
    t.string "title_en"
    t.string "title_fr"
    t.text "description_ca"
    t.text "description_es"
    t.text "description_en"
    t.text "description_fr"
    t.integer "bedrooms"
    t.boolean "terrace"
    t.boolean "lift"
    t.boolean "featured", default: false
    t.bigint "town_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["town_id"], name: "index_listings_on_town_id"
    t.index ["user_id"], name: "index_listings_on_user_id"
  end

  create_table "towns", force: :cascade do |t|
    t.string "name_ca"
    t.string "name_es"
    t.string "name_en"
    t.string "name_fr"
    t.text "description_ca"
    t.text "description_es"
    t.text "description_en"
    t.text "description_fr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "listings", "towns"
  add_foreign_key "listings", "users"
end
