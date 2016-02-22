# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160222114647) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alerts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "message"
    t.boolean  "read",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "post_id"
    t.integer  "dib_id"
    t.integer  "sender_id"
  end

  add_index "alerts", ["user_id", "post_id", "sender_id", "dib_id"], name: "index_alerts_on_user_id_and_post_id_and_sender_id_and_dib_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "dibs", force: :cascade do |t|
    t.string   "ip",          null: false
    t.datetime "valid_until", null: false
    t.string   "status",      null: false
    t.integer  "creator_id",  null: false
    t.integer  "post_id",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dibs", ["post_id", "creator_id"], name: "index_dibs_on_post_id_and_creator_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "images", ["imageable_id"], name: "index_images_on_imageable_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "image_url"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "on_the_curb",        default: false
    t.string   "phone_number"
    t.string   "status",                             null: false
    t.string   "ip",                                 null: false
    t.datetime "dibbed_until"
    t.integer  "creator_id",                         null: false
    t.integer  "dibber_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "category"
    t.boolean  "published",          default: true
    t.integer  "current_dib_id"
  end

  add_index "posts", ["dibber_id"], name: "index_posts_on_dibber_id", using: :btree
  add_index "posts", ["latitude", "longitude", "title", "status", "dibbed_until", "created_at"], name: "posts_idx", using: :btree
  add_index "posts", ["status", "dibbed_until", "created_at"], name: "posts_two_idx", using: :btree

  create_table "reports", force: :cascade do |t|
    t.integer  "dib_id"
    t.string   "description"
    t.integer  "rating",      default: 5
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                                null: false
    t.string   "password_digest",                      null: false
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "grid_mode"
    t.integer  "zoom"
    t.string   "phone_number"
    t.string   "status",                               null: false
    t.string   "ip",                                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.boolean  "anonymous",            default: false
    t.string   "password_reset_token"
    t.string   "provider"
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.boolean  "verified_email",       default: false
    t.string   "verify_email_token"
    t.boolean  "admin",                default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["password_reset_token"], name: "index_users_on_password_reset_token", using: :btree
  add_index "users", ["username", "oauth_token"], name: "index_users_on_username_and_oauth_token", using: :btree
  add_index "users", ["verify_email_token"], name: "index_users_on_verify_email_token", using: :btree

end
