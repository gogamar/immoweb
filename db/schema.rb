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

ActiveRecord::Schema[7.0].define(version: 2024_05_11_080611) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "email"
    t.text "message"
    t.string "budget"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contents", force: :cascade do |t|
    t.string "header_background"
    t.string "header_title_ca"
    t.string "header_title_es"
    t.string "header_title_en"
    t.string "header_title_fr"
    t.string "action_phrase_ca"
    t.string "action_phrase_es"
    t.string "action_phrase_en"
    t.string "action_phrase_fr"
    t.string "action_button_ca"
    t.string "action_button_es"
    t.string "action_button_en"
    t.string "action_button_fr"
    t.string "reviews_title_ca"
    t.string "reviews_title_es"
    t.string "reviews_title_en"
    t.string "reviews_title_fr"
    t.string "reviews_subtitle_ca"
    t.string "reviews_subtitle_es"
    t.string "reviews_subtitle_en"
    t.string "reviews_subtitle_fr"
    t.string "add_property_title_ca"
    t.string "add_property_title_es"
    t.string "add_property_title_en"
    t.string "add_property_title_fr"
    t.string "add_property_subtitle_ca"
    t.string "add_property_subtitle_es"
    t.string "add_property_subtitle_en"
    t.string "add_property_subtitle_fr"
    t.string "posts_title_ca"
    t.string "posts_title_es"
    t.string "posts_title_en"
    t.string "posts_title_fr"
    t.string "posts_subtitle_ca"
    t.string "posts_subtitle_es"
    t.string "posts_subtitle_en"
    t.string "posts_subtitle_fr"
    t.string "contact_title_ca"
    t.string "contact_title_es"
    t.string "contact_title_en"
    t.string "contact_title_fr"
    t.string "contact_subtitle_ca"
    t.string "contact_subtitle_es"
    t.string "contact_subtitle_en"
    t.string "contact_subtitle_fr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "features", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "image_urls", force: :cascade do |t|
    t.string "caption"
    t.string "url"
    t.bigint "listing_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["listing_id"], name: "index_image_urls_on_listing_id"
  end

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
    t.string "listing_subtype"
    t.boolean "new_build"
    t.boolean "bank_owned"
    t.string "town_area"
    t.string "loc_precision"
    t.string "preservation"
    t.string "year_built"
    t.string "energy_cert"
    t.integer "double_bedrooms"
    t.integer "single_bedrooms"
    t.integer "bathrooms"
    t.string "town_name"
    t.string "local_status"
    t.string "mark"
    t.date "published_on"
    t.index ["town_id"], name: "index_listings_on_town_id"
    t.index ["user_id"], name: "index_listings_on_user_id"
  end

  create_table "listings_features", id: false, force: :cascade do |t|
    t.bigint "listing_id"
    t.bigint "feature_id"
    t.index ["feature_id"], name: "index_listings_features_on_feature_id"
    t.index ["listing_id", "feature_id"], name: "index_listings_features_on_listing_id_and_feature_id", unique: true
    t.index ["listing_id"], name: "index_listings_features_on_listing_id"
  end

  create_table "offices", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
  end

  create_table "services", force: :cascade do |t|
    t.string "summary_title_ca"
    t.string "summary_title_es"
    t.string "summary_title_en"
    t.string "summary_title_fr"
    t.text "summary_ca"
    t.text "summary_es"
    t.text "summary_en"
    t.text "summary_fr"
    t.string "description_title_ca"
    t.string "description_title_es"
    t.string "description_title_en"
    t.string "description_title_fr"
    t.text "description_ca"
    t.text "description_es"
    t.text "description_en"
    t.text "description_fr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "image_urls", "listings"
  add_foreign_key "listings", "towns"
  add_foreign_key "listings", "users"
end
