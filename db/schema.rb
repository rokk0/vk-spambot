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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120506102646) do

  create_table "accounts", :force => true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.string   "password"
    t.integer  "code"
    t.boolean  "approved"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "accounts", ["email"], :name => "index_accounts_on_email", :unique => true
  add_index "accounts", ["user_id"], :name => "index_accounts_on_user_id"

  create_table "bots", :force => true do |t|
    t.integer  "account_id"
    t.string   "bot_type"
    t.string   "page"
    t.string   "page_title"
    t.string   "page_hash"
    t.text     "message"
    t.integer  "count"
    t.string   "interval"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "bots", ["account_id"], :name => "index_bots_on_account_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin",              :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
