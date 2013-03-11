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

ActiveRecord::Schema.define(:version => 20130309055215) do

  create_table "associations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "associate_id"
    t.string   "relation_type"
    t.string   "relation"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "associations", ["user_id"], :name => "index_associations_on_user_id"

  create_table "attachments", :force => true do |t|
    t.string   "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "authors", :force => true do |t|
    t.string   "name"
    t.string   "imageURL"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "shortName"
  end

  create_table "authors_contents", :force => true do |t|
    t.integer  "author_id"
    t.integer  "content_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "contents", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "contentsType"
    t.text     "abstract"
    t.text     "question"
    t.text     "keywords"
    t.datetime "updateDate"
  end

  create_table "contents_vocabularies", :force => true do |t|
    t.integer  "content_id"
    t.integer  "mayo_vocabulary_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "diseases", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "feedbacks", :force => true do |t|
    t.integer  "user_id"
    t.string   "note"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "feedbacks", ["user_id"], :name => "index_feedbacks_on_user_id"

  create_table "institutions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "institutions_users", :force => true do |t|
    t.integer  "institution_id"
    t.integer  "user_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "mayo_vocabularies", :force => true do |t|
    t.string   "mcvid"
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "mayo_vocabularies_messages", :force => true do |t|
    t.integer  "mayo_vocabulary_id"
    t.integer  "message_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "messages", :force => true do |t|
    t.string   "text"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_diseases", :force => true do |t|
    t.integer  "user_id"
    t.integer  "disease_id"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "being_treated"
    t.boolean  "diagnosed"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "user_diseases", ["disease_id"], :name => "index_user_diseases_on_disease_id"
  add_index "user_diseases", ["user_id"], :name => "index_user_diseases_on_user_id"

  create_table "user_locations", :force => true do |t|
    t.integer  "user_id"
    t.decimal  "latitude",   :precision => 10, :scale => 6
    t.decimal  "longitude",  :precision => 10, :scale => 6
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
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.date     "birth_date"
    t.datetime "created_at",                                                                                   :null => false
    t.datetime "updated_at",                                                                                   :null => false
    t.string   "image_url"
    t.string   "install_id",                      :limit => 36
    t.string   "email"
    t.decimal  "height",                                        :precision => 6, :scale => 2, :default => 0.0
    t.string   "phone"
    t.string   "generic_call_time"
    t.string   "crypted_password"
    t.string   "auth_token"
    t.string   "salt"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
  end

  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token"

end
