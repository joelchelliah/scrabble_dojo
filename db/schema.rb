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

ActiveRecord::Schema.define(version: 20131005141625) do

  create_table "memos", force: true do |t|
    t.string   "name"
    t.text     "hints"
    t.text     "word_list"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "health_decay"
    t.integer  "num_practices",     default: 0
    t.integer  "user_id"
    t.text     "accepted_words"
    t.float    "best_time"
    t.boolean  "practice_disabled", default: false
  end

  add_index "memos", ["user_id", "name"], name: "index_memos_on_user_id_and_name", unique: true

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

  create_table "word_entries", force: true do |t|
    t.string   "word"
    t.string   "letters"
    t.integer  "length"
    t.string   "first_letter"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "word_entries", ["letters"], name: "index_word_entries_on_letters"
  add_index "word_entries", ["word"], name: "index_word_entries_on_word", unique: true

end
