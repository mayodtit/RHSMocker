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

ActiveRecord::Schema.define(:version => 20140113213052) do

  create_table "addresses", :force => true do |t|
    t.integer  "user_id"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "agreements", :force => true do |t|
    t.text     "text"
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
    t.string   "description"
    t.string   "image"
    t.integer  "symptom_id"
  end

  create_table "content_mayo_vocabularies", :force => true do |t|
    t.integer  "content_id"
    t.integer  "mayo_vocabulary_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "content_references", :force => true do |t|
    t.integer  "referrer_id"
    t.integer  "referee_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "contents", :force => true do |t|
    t.string   "title",                  :default => "",    :null => false
    t.text     "raw_body"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "content_type",           :default => "",    :null => false
    t.text     "abstract"
    t.text     "question"
    t.text     "keywords"
    t.datetime "content_updated_at"
    t.string   "document_id",            :default => "",    :null => false
    t.boolean  "show_call_option",       :default => true,  :null => false
    t.boolean  "show_checker_option",    :default => true,  :null => false
    t.boolean  "show_mayo_copyright",    :default => true,  :null => false
    t.string   "type"
    t.text     "raw_preview"
    t.string   "state"
    t.boolean  "sensitive",              :default => false, :null => false
    t.string   "symptom_checker_gender"
  end

  add_index "contents", ["document_id"], :name => "index_contents_on_document_id"

  create_table "credits", :force => true do |t|
    t.integer  "offering_id"
    t.integer  "user_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "unlimited",   :default => false, :null => false
  end

  create_table "custom_cards", :force => true do |t|
    t.integer  "content_id"
    t.string   "title"
    t.text     "raw_preview"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.text     "card_actions"
    t.text     "timeline_action"
    t.integer  "priority",        :default => 0, :null => false
  end

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

  create_table "factor_contents", :force => true do |t|
    t.integer  "factor_id"
    t.integer  "content_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "factor_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "symptom_id"
    t.integer  "ordinal"
  end

  create_table "factors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "gender"
    t.integer  "factor_group_id"
  end

  create_table "feature_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.text     "metadata_override"
  end

  create_table "insurance_policies", :force => true do |t|
    t.integer  "user_id"
    t.string   "company_name"
    t.string   "plan_type"
    t.string   "policy_member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", :force => true do |t|
    t.integer  "member_id"
    t.integer  "invited_member_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "token"
    t.string   "state"
  end

  add_index "invitations", ["token"], :name => "index_invitations_on_token"

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
    t.string   "image"
    t.integer  "phone_call_summary_id"
  end

  add_index "messages", ["content_id"], :name => "index_messages_on_content_id"

  create_table "metadata", :force => true do |t|
    t.string   "mkey",       :null => false
    t.string   "mvalue",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

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

  create_table "phone_call_summaries", :force => true do |t|
    t.integer  "caller_id",  :null => false
    t.integer  "callee_id",  :null => false
    t.text     "body",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "phone_calls", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.string   "origin_phone_number"
    t.string   "destination_phone_number"
    t.string   "state"
    t.datetime "claimed_at"
    t.datetime "ended_at"
    t.integer  "claimer_id"
    t.integer  "ender_id"
    t.string   "identifier_token"
    t.integer  "to_role_id",               :default => 1, :null => false
  end

  add_index "phone_calls", ["claimer_id"], :name => "index_phone_calls_on_claimer_id"
  add_index "phone_calls", ["ender_id"], :name => "index_phone_calls_on_ender_id"
  add_index "phone_calls", ["identifier_token"], :name => "index_phone_calls_on_identifier_token"
  add_index "phone_calls", ["state"], :name => "index_phone_calls_on_state"
  add_index "phone_calls", ["to_role_id"], :name => "index_phone_calls_on_to_role_id"

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
    t.boolean  "monthly"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "program_resources", :force => true do |t|
    t.integer  "program_id"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "ordinal"
  end

  create_table "programs", :force => true do |t|
    t.string   "title",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "providers", :force => true do |t|
    t.integer  "user_id"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", :force => true do |t|
    t.string   "title"
    t.string   "view"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

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
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.datetime "disabled_at"
    t.integer  "owner_id"
    t.string   "state",                :default => "unassigned"
    t.integer  "assignor_id"
    t.datetime "assigned_at"
    t.integer  "booker_id"
    t.datetime "booked_at"
    t.integer  "starter_id"
    t.datetime "started_at"
    t.integer  "canceler_id"
    t.datetime "canceled_at"
    t.integer  "ender_id"
    t.datetime "ended_at"
    t.integer  "scheduled_duration_s", :default => 1800,         :null => false
  end

  create_table "side_effects", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "plan_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "symptom_medical_advice_items", :force => true do |t|
    t.text     "description"
    t.integer  "symptom_medical_advice_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "gender"
  end

  add_index "symptom_medical_advice_items", ["symptom_medical_advice_id"], :name => "index_symptom_medical_advice_items_on_symptom_medical_advice_id"

  create_table "symptom_medical_advices", :force => true do |t|
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "symptom_id"
  end

  add_index "symptom_medical_advices", ["symptom_id"], :name => "index_symptom_medical_advices_on_symptom_id"

  create_table "symptom_selfcare_items", :force => true do |t|
    t.text     "description"
    t.integer  "symptom_selfcare_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "symptom_selfcare_items", ["symptom_selfcare_id"], :name => "index_symptom_selfcare_items_on_symptom_selfcare_id"

  create_table "symptom_selfcares", :force => true do |t|
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "symptom_id"
  end

  create_table "symptoms", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "patient_type"
    t.string   "description"
    t.string   "gender"
  end

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

  create_table "user_content_likes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "content_id"
    t.string   "action"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_feature_groups", :force => true do |t|
    t.integer  "user_id"
    t.integer  "feature_group_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "user_informations", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "notes"
  end

  create_table "user_readings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "content_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "viewed_count",    :default => 0, :null => false
    t.integer  "saved_count",     :default => 0, :null => false
    t.integer  "dismissed_count", :default => 0, :null => false
    t.integer  "shared_count",    :default => 0, :null => false
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
    t.string   "avatar"
    t.string   "install_id",                      :limit => 36
    t.string   "email"
    t.decimal  "height",                                        :precision => 9, :scale => 5
    t.string   "phone"
    t.string   "crypted_password"
    t.string   "auth_token"
    t.string   "salt"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
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
    t.string   "google_analytics_uuid",           :limit => 36
    t.string   "avatar_url_override"
    t.text     "client_data"
    t.string   "work_phone_number"
  end

  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token"

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

  create_table "waitlist_entries", :force => true do |t|
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "token"
    t.string   "state"
    t.datetime "invited_at"
    t.datetime "claimed_at"
    t.integer  "member_id"
  end

  create_table "weights", :force => true do |t|
    t.integer  "user_id"
    t.decimal  "amount",     :precision => 9, :scale => 5, :default => 0.0
    t.decimal  "bmi",        :precision => 8, :scale => 5
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
    t.datetime "taken_at"
  end

end
