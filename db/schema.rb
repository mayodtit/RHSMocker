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

ActiveRecord::Schema.define(:version => 20130216015248) do

  create_table "authors", :force => true do |t|
    t.string   "name"
    t.string   "imageURL"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "shortName"
  end

  create_table "content_authors", :force => true do |t|
    t.integer  "user_id"
    t.integer  "content_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "content_keywords", :force => true do |t|
    t.string   "name"
    t.boolean  "default"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "contents", :force => true do |t|
    t.string   "title"
    t.text     "body",         :limit => 25000
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "author_id"
    t.string   "contentsType"
    t.text     "abstract"
    t.text     "question"
    t.text     "keywords"
  end

  create_table "user_locations", :force => true do |t|
    t.integer  "user_id"
    t.decimal  "lat",        :precision => 10, :scale => 6
    t.decimal  "long",       :precision => 10, :scale => 6
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "user_readings", :force => true do |t|
    t.datetime "read_date"
    t.integer  "user_id"
    t.integer  "content_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.datetime "read_later_date"
    t.integer  "read_later_count", :default => 0
    t.datetime "dismiss_date"
  end

  create_table "user_weights", :force => true do |t|
    t.integer  "user_id"
    t.decimal  "weight",     :precision => 6, :scale => 2, :default => 0.0
    t.decimal  "bmi",        :precision => 5, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "firstName"
    t.string   "lastName"
    t.string   "gender"
    t.date     "birthDate"
    t.datetime "created_at",                                                                     :null => false
    t.datetime "updated_at",                                                                     :null => false
    t.string   "imageURL"
    t.string   "uuid",              :limit => 32
    t.string   "install_id",        :limit => 36
    t.string   "email"
    t.decimal  "height",                          :precision => 6, :scale => 2, :default => 0.0
    t.string   "phone"
    t.string   "generic_call_time"
  end

end
