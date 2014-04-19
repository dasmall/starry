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

ActiveRecord::Schema.define(version: 20140419022158) do

  create_table "favorite_categories", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorite_categories", ["user_id"], name: "index_favorite_categories_on_user_id"

  create_table "favorite_categories_favorite_tweets", id: false, force: true do |t|
    t.integer "favorite_category_id", null: false
    t.integer "favorite_tweet_id",    null: false
  end

  create_table "favorite_tweets", force: true do |t|
    t.text     "text"
    t.datetime "date_posted"
    t.integer  "user_id",        limit: 255
    t.text     "raw_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "favorite_count"
    t.integer  "status_id"
  end

  create_table "favorites", force: true do |t|
    t.string   "text"
    t.string   "stag"
    t.string   "status_id"
    t.integer  "user_id"
    t.string   "raw_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id"

  create_table "users", force: true do |t|
    t.string   "uid"
    t.string   "username"
    t.string   "profile_photo"
    t.string   "access_token"
    t.string   "access_token_secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["uid"], name: "index_users_on_uid", unique: true

end
