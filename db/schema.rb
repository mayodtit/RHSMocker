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

ActiveRecord::Schema.define(:version => 20130403212354) do

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
    t.integer  "message_id"
  end

  add_index "attachments", ["message_id"], :name => "index_attachments_on_message_id"

  create_table "authors", :force => true do |t|
    t.string   "name"
    t.string   "image_url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "short_name"
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

  create_table "contents_mayo_vocabularies", :force => true do |t|
    t.integer  "content_id"
    t.integer  "mayo_vocabulary_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "contents_symptoms", :force => true do |t|
    t.integer  "content_id"
    t.integer  "symptom_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "contents_symptoms", ["content_id"], :name => "index_contents_symptoms_on_content_id"
  add_index "contents_symptoms", ["symptom_id"], :name => "index_contents_symptoms_on_symptom_id"

  create_table "contents_symptoms_factors", :force => true do |t|
    t.integer  "content_id"
    t.integer  "symptoms_factor_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "contents_symptoms_factors", ["content_id"], :name => "index_contents_symptom_factors_on_content_id"
  add_index "contents_symptoms_factors", ["symptoms_factor_id"], :name => "index_contents_symptom_factors_on_symptom_factor_id"

  create_table "diseases", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "encounters", :force => true do |t|
    t.string   "status"
    t.string   "priority"
    t.boolean  "checked"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "encounters_users", :force => true do |t|
    t.string   "role"
    t.integer  "encounter_id"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.boolean  "read"
  end

  add_index "encounters_users", ["encounter_id"], :name => "index_encounters_users_on_encounter_id"
  add_index "encounters_users", ["user_id"], :name => "index_encounters_users_on_user_id"

  create_table "factor_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "factors", :force => true do |t|
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

  create_table "message_statuses", :force => true do |t|
    t.integer  "message_id"
    t.integer  "user_id"
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "message_statuses", ["message_id"], :name => "index_message_statuses_on_message_id"
  add_index "message_statuses", ["user_id"], :name => "index_message_statuses_on_user_id"

  create_table "messages", :force => true do |t|
    t.text     "text"
    t.integer  "user_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "user_location_id"
    t.integer  "encounter_id"
    t.integer  "content_id"
  end

  add_index "messages", ["content_id"], :name => "index_messages_on_content_id"

  create_table "phone_calls", :force => true do |t|
    t.string   "time_to_call"
    t.string   "time_zone"
    t.string   "status"
    t.text     "summary"
    t.datetime "start_time"
    t.integer  "counter"
    t.integer  "message_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "phone_calls", ["message_id"], :name => "index_phone_calls_on_message_id"

  create_table "symptoms", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "patient_type"
  end

  create_table "symptoms_factors", :force => true do |t|
    t.boolean  "doctor_call_worthy"
    t.boolean  "er_worthy"
    t.integer  "symptom_id"
    t.integer  "factor_id"
    t.integer  "factor_group_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "symptoms_factors", ["factor_group_id"], :name => "index_symptoms_factors_on_factor_group_id"
  add_index "symptoms_factors", ["factor_id"], :name => "index_symptoms_factors_on_factor_id"
  add_index "symptoms_factors", ["symptom_id"], :name => "index_symptoms_factors_on_symptom_id"

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
    t.string   "feature_bucket"
  end

  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token"

end
