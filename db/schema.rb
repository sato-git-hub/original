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

ActiveRecord::Schema[7.2].define(version: 2026_01_31_083103) do
  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
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

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "characters", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "hair_color"
    t.string "hair_style"
    t.string "hair_type"
    t.string "hair_length"
    t.string "skin_tone"
    t.integer "height"
    t.string "body_type"
    t.string "body_frame"
    t.string "personal_color"
    t.integer "age"
    t.string "sex"
    t.string "eye_color"
    t.string "eye_shape"
    t.string "mbti"
    t.boolean "glasses"
    t.string "face_type"
    t.string "face_shape"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "request_id", null: false
    t.string "bang_style"
    t.index ["request_id"], name: "index_characters_on_request_id"
  end

  create_table "portfolios", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.boolean "published", default: false, null: false
    t.index ["user_id"], name: "index_portfolios_on_user_id", unique: true
  end

  create_table "requests", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title", null: false
    t.text "body", null: false
    t.bigint "user_id", null: false
    t.bigint "creator_id", null: false
    t.integer "current_amount", default: 0, null: false
    t.integer "lowest_amount", default: 0, null: false
    t.integer "target_amount", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.integer "approval_status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published", default: false, null: false
    t.datetime "approved_at", precision: nil
    t.datetime "deadline_at", precision: nil
    t.text "search_conf"
    t.index ["creator_id"], name: "index_requests_on_creator_id"
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "support_histories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "request_id", null: false
    t.integer "amount", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "payjp_charge_id", default: "", null: false
    t.integer "status", default: 0, null: false
    t.index ["request_id"], name: "index_support_histories_on_request_id"
    t.index ["user_id"], name: "index_support_histories_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "comment", default: ""
    t.string "twitter"
    t.string "facebook"
    t.string "instagram"
    t.string "pixiv"
    t.string "payjp_customer_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "characters", "requests"
  add_foreign_key "portfolios", "users"
  add_foreign_key "requests", "users"
  add_foreign_key "requests", "users", column: "creator_id"
  add_foreign_key "support_histories", "requests"
  add_foreign_key "support_histories", "users"
end
