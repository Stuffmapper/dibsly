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

ActiveRecord::Schema.define(version: 20150413233307) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dibs", force: :cascade do |t|
    t.string   "ip",          limit: 255, null: false
    t.datetime "valid_until",             null: false
    t.string   "status",      limit: 255, null: false
    t.integer  "creator_id",              null: false
    t.integer  "post_id",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mailboxer_conversation_opt_outs", force: :cascade do |t|
    t.integer "unsubscriber_id"
    t.string  "unsubscriber_type"
    t.integer "conversation_id"
  end

  add_index "mailboxer_conversation_opt_outs", ["conversation_id"], name: "index_mailboxer_conversation_opt_outs_on_conversation_id", using: :btree
  add_index "mailboxer_conversation_opt_outs", ["unsubscriber_id", "unsubscriber_type"], name: "index_mailboxer_conversation_opt_outs_on_unsubscriber_id_type", using: :btree

  create_table "mailboxer_conversations", force: :cascade do |t|
    t.string   "subject",    default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "mailboxer_notifications", force: :cascade do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              default: ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                default: false
    t.string   "notification_code"
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "attachment"
    t.datetime "updated_at",                           null: false
    t.datetime "created_at",                           null: false
    t.boolean  "global",               default: false
    t.datetime "expires"
  end

  add_index "mailboxer_notifications", ["conversation_id"], name: "index_mailboxer_notifications_on_conversation_id", using: :btree
  add_index "mailboxer_notifications", ["notified_object_id", "notified_object_type"], name: "index_mailboxer_notifications_on_notified_object_id_and_type", using: :btree
  add_index "mailboxer_notifications", ["sender_id", "sender_type"], name: "index_mailboxer_notifications_on_sender_id_and_sender_type", using: :btree
  add_index "mailboxer_notifications", ["type"], name: "index_mailboxer_notifications_on_type", using: :btree

  create_table "mailboxer_receipts", force: :cascade do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                            null: false
    t.boolean  "is_read",                    default: false
    t.boolean  "trashed",                    default: false
    t.boolean  "deleted",                    default: false
    t.string   "mailbox_type",    limit: 25
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "mailboxer_receipts", ["notification_id"], name: "index_mailboxer_receipts_on_notification_id", using: :btree
  add_index "mailboxer_receipts", ["receiver_id", "receiver_type"], name: "index_mailboxer_receipts_on_receiver_id_and_receiver_type", using: :btree

  create_table "messages", force: :cascade do |t|
    t.string   "ip",            limit: 255, null: false
    t.string   "status",        limit: 255, null: false
    t.integer  "sender_id",                 null: false
    t.string   "sender_name",   limit: 255, null: false
    t.integer  "receiver_id",               null: false
    t.string   "receiver_name", limit: 255, null: false
    t.text     "content",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: :cascade do |t|
    t.string   "title",              limit: 255
    t.text     "description"
    t.string   "image_url",          limit: 255
    t.string   "address",            limit: 255
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "on_the_curb"
    t.string   "phone_number",       limit: 255
    t.string   "status",             limit: 255, null: false
    t.string   "ip",                 limit: 255, null: false
    t.datetime "dibbed_until"
    t.integer  "creator_id",                     null: false
    t.integer  "dibber_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "contact_email",      limit: 255
    t.string   "category",           limit: 255
  end

  add_index "posts", ["latitude", "longitude", "title", "status", "dibbed_until", "created_at"], name: "posts_idx", using: :btree
  add_index "posts", ["status", "dibbed_until", "created_at"], name: "posts_two_idx", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                limit: 255,                 null: false
    t.string   "password_salt",        limit: 255,                 null: false
    t.string   "password_hash",        limit: 255,                 null: false
    t.string   "address",              limit: 255
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "grid_mode"
    t.integer  "zoom"
    t.string   "phone_number",         limit: 255
    t.string   "status",               limit: 255,                 null: false
    t.string   "ip",                   limit: 255,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uid",                  limit: 255
    t.string   "provider",             limit: 255
    t.string   "oauth_token",          limit: 255
    t.datetime "oauth_expires_at"
    t.string   "invite_code",          limit: 255
    t.string   "first_name",           limit: 255
    t.string   "last_name",            limit: 255
    t.string   "username",             limit: 255
    t.boolean  "anonymous",                        default: false
    t.string   "password_reset_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["password_reset_token"], name: "index_users_on_password_reset_token", using: :btree

  add_foreign_key "mailboxer_conversation_opt_outs", "mailboxer_conversations", column: "conversation_id", name: "mb_opt_outs_on_conversations_id"
  add_foreign_key "mailboxer_notifications", "mailboxer_conversations", column: "conversation_id", name: "notifications_on_conversation_id"
  add_foreign_key "mailboxer_receipts", "mailboxer_notifications", column: "notification_id", name: "receipts_on_notification_id"
end
