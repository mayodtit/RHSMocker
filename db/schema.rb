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

ActiveRecord::Schema.define(:version => 20130918181711) do

  create_table "agreements", :force => true do |t|
    t.text     "text"
    t.string   "type"
    t.boolean  "active",     :default => false, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "allergies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "snomed_name"
    t.string   "snomed_code"
    t.boolean  "food_allergen"
    t.boolean  "environment_allergen"
    t.boolean  "medication_allergen"
    t.datetime "disabled_at"
  end

  create_table "api_users", :force => true do |t|
    t.string   "name"
    t.string   "auth_token"
    t.datetime "disabled_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "association_types", :force => true do |t|
    t.string   "name"
    t.string   "relationship_type"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "gender"
    t.datetime "disabled_at"
  end

  create_table "associations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "associate_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "association_type_id"
  end

  add_index "associations", ["user_id"], :name => "index_associations_on_user_id"

  create_table "attachments", :force => true do |t|
    t.string   "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "message_id"
  end

  add_index "attachments", ["message_id"], :name => "index_attachments_on_message_id"

  create_table "blood_pressures", :force => true do |t|
    t.integer  "systolic"
    t.integer  "diastolic"
    t.integer  "pulse"
    t.integer  "collection_type_id"
    t.integer  "user_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.datetime "taken_at"
  end

  add_index "blood_pressures", ["collection_type_id"], :name => "index_blood_pressures_on_collection_type_id"
  add_index "blood_pressures", ["user_id"], :name => "index_blood_pressures_on_user_id"

  create_table "cards", :force => true do |t|
    t.integer  "user_id"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.string   "state"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "priority",         :null => false
    t.datetime "state_changed_at"
  end

  create_table "collection_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "conditions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "snomed_name"
    t.string   "snomed_code"
    t.datetime "disabled_at"
  end

  create_table "consult_users", :force => true do |t|
    t.string   "role"
    t.integer  "consult_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "read"
  end

  create_table "consults", :force => true do |t|
    t.string   "status"
    t.string   "priority"
    t.boolean  "checked"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "subject_id",   :default => 0, :null => false
    t.integer  "initiator_id", :default => 0, :null => false
    t.string   "title"
  end

  create_table "content_mayo_vocabularies", :force => true do |t|
    t.integer  "content_id"
    t.integer  "mayo_vocabulary_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "contents", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "content_type"
    t.text     "abstract"
    t.text     "question"
    t.text     "keywords"
    t.datetime "content_updated_at"
    t.string   "mayo_doc_id"
    t.boolean  "show_call_option"
    t.boolean  "show_checker_option"
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

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "diets", :force => true do |t|
    t.string   "name",        :default => "", :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "ordinal",     :default => 0,  :null => false
    t.datetime "disabled_at"
  end

  create_table "ethnic_groups", :force => true do |t|
    t.string   "name",           :default => "", :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "ethnicity_code", :default => 0,  :null => false
    t.integer  "ordinal",        :default => 0,  :null => false
    t.datetime "disabled_at"
  end

  create_table "factor_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "order"
  end

  create_table "factors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "invitations", :force => true do |t|
    t.integer  "member_id"
    t.integer  "invited_member_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "locations", :force => true do |t|
    t.integer  "user_id"
    t.decimal  "latitude",   :precision => 10, :scale => 6
    t.decimal  "longitude",  :precision => 10, :scale => 6
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "mayo_vocabularies", :force => true do |t|
    t.string   "mcvid"
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "message_mayo_vocabularies", :force => true do |t|
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
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "location_id"
    t.integer  "consult_id"
    t.integer  "content_id"
    t.integer  "scheduled_phone_call_id"
    t.integer  "phone_call_id"
  end

  add_index "messages", ["content_id"], :name => "index_messages_on_content_id"

  create_table "nurseline_records", :force => true do |t|
    t.text     "payload"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "api_user_id"
    t.datetime "disabled_at"
  end

  create_table "offerings", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "phone_calls", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "origin_phone_number"
    t.string   "destination_phone_number"
  end

  create_table "plan_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "plan_offerings", :force => true do |t|
    t.integer  "plan_id"
    t.integer  "offering_id"
    t.integer  "amount"
    t.boolean  "unlimited"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "plan_offerings", ["offering_id"], :name => "index_plan_offerings_on_offering_id"
  add_index "plan_offerings", ["plan_id"], :name => "index_plan_offerings_on_plan_id"

  create_table "plans", :force => true do |t|
    t.string   "name"
    t.integer  "plan_group_id"
    t.boolean  "monthly"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "plans", ["plan_group_id"], :name => "index_plans_on_plan_group_id"

  create_table "remote_events", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.text     "data"
    t.integer  "user_id"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "scheduled_phone_calls", :force => true do |t|
    t.integer  "user_id"
    t.integer  "phone_call_id"
    t.datetime "scheduled_at"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.datetime "disabled_at"
  end

  create_table "side_effects", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

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

  create_table "treatment_side_effects", :force => true do |t|
    t.integer  "treatment_id"
    t.integer  "side_effect_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "treatments", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "snomed_name"
    t.string   "snomed_code"
    t.string   "type"
    t.datetime "disabled_at"
  end

  create_table "user_agreements", :force => true do |t|
    t.integer  "user_id"
    t.integer  "agreement_id"
    t.string   "user_agent"
    t.string   "ip_address"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "user_allergies", :force => true do |t|
    t.integer  "user_id"
    t.integer  "allergy_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_allergies", ["allergy_id"], :name => "index_user_allergies_on_allergy_id"
  add_index "user_allergies", ["user_id"], :name => "index_user_allergies_on_user_id"

  create_table "user_condition_user_treatments", :force => true do |t|
    t.integer  "user_condition_id", :null => false
    t.integer  "user_treatment_id", :null => false
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "user_conditions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "condition_id"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "being_treated"
    t.boolean  "diagnosed"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "diagnoser_id"
    t.datetime "diagnosed_date"
  end

  create_table "user_offerings", :force => true do |t|
    t.integer  "offering_id"
    t.integer  "user_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "unlimited",   :default => false, :null => false
  end

  add_index "user_offerings", ["offering_id"], :name => "index_user_offerings_on_offering_id"
  add_index "user_offerings", ["user_id"], :name => "index_user_offerings_on_user_id"

  create_table "user_plans", :force => true do |t|
    t.integer  "plan_id"
    t.integer  "user_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.date     "cancellation_date"
  end

  add_index "user_plans", ["plan_id"], :name => "index_user_plans_on_plan_id"
  add_index "user_plans", ["user_id"], :name => "index_user_plans_on_user_id"

  create_table "user_readings", :force => true do |t|
    t.datetime "read_date"
    t.integer  "user_id"
    t.integer  "content_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.datetime "save_date"
    t.integer  "save_count",    :default => 0
    t.datetime "dismiss_date"
    t.datetime "view_date"
    t.integer  "share_counter"
    t.integer  "priority",      :default => 0, :null => false
  end

  create_table "user_treatment_side_effects", :force => true do |t|
    t.integer  "user_treatment_id"
    t.integer  "side_effect_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "user_treatments", :force => true do |t|
    t.boolean  "prescribed_by_doctor"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "time_duration"
    t.string   "time_duration_unit"
    t.integer  "amount"
    t.string   "amount_unit"
    t.boolean  "side_effect"
    t.boolean  "successful"
    t.integer  "treatment_id"
    t.integer  "user_id"
    t.integer  "doctor_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.date     "birth_date"
    t.datetime "created_at",                                                                                     :null => false
    t.datetime "updated_at",                                                                                     :null => false
    t.string   "image_url"
    t.string   "install_id",                      :limit => 36
    t.string   "email"
    t.decimal  "height",                                        :precision => 9, :scale => 5
    t.string   "phone"
    t.string   "generic_call_time"
    t.string   "crypted_password"
    t.string   "auth_token"
    t.string   "salt"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.string   "feature_bucket"
    t.integer  "ethnic_group_id"
    t.integer  "diet_id"
    t.string   "blood_type"
    t.string   "holds_phone_in"
    t.string   "npi_number",                      :limit => 10
    t.date     "date_of_death"
    t.string   "expertise"
    t.boolean  "deceased",                                                                    :default => false, :null => false
    t.string   "city"
    t.string   "state"
    t.string   "type",                                                                        :default => "",    :null => false
    t.string   "invitation_token"
    t.string   "units",                                                                       :default => "US",  :null => false
    t.string   "stripe_customer_id"
    t.string   "mixpanel_uuid",                   :limit => 36
    t.string   "google_analytics_uuid",           :limit => 36
  end

  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token"

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

  create_table "weights", :force => true do |t|
    t.integer  "user_id"
    t.decimal  "amount",     :precision => 9, :scale => 5, :default => 0.0
    t.decimal  "bmi",        :precision => 8, :scale => 5
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
    t.datetime "taken_at"
  end

end
