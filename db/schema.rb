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

ActiveRecord::Schema.define(:version => 20150728182553) do

  create_table "addresses", :force => true do |t|
    t.integer  "user_id"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "address2"
    t.string   "name"
  end

  add_index "addresses", ["user_id"], :name => "index_addresses_on_user_id"

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
    t.string   "concept_id"
    t.string   "description_id"
    t.integer  "master_synonym_id"
  end

  create_table "api_users", :force => true do |t|
    t.string   "name"
    t.string   "auth_token"
    t.datetime "disabled_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "appointments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "provider_id"
    t.datetime "scheduled_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "appointments", ["user_id"], :name => "index_appointments_on_user_id"

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
    t.string   "state"
    t.integer  "replacement_id"
    t.integer  "pair_id"
    t.integer  "creator_id"
    t.integer  "parent_id"
  end

  add_index "associations", ["associate_id"], :name => "index_associations_on_associate_id"
  add_index "associations", ["association_type_id"], :name => "index_associations_on_association_type_id"
  add_index "associations", ["creator_id"], :name => "index_associations_on_creator_id"
  add_index "associations", ["replacement_id"], :name => "index_associations_on_replacement_id"
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
    t.string   "healthkit_uuid"
    t.string   "healthkit_source"
  end

  add_index "blood_pressures", ["collection_type_id"], :name => "index_blood_pressures_on_collection_type_id"
  add_index "blood_pressures", ["user_id"], :name => "index_blood_pressures_on_user_id"

  create_table "bmi_data_levels", :force => true do |t|
    t.string   "gender"
    t.integer  "age_in_months"
    t.float    "power_in_transformation"
    t.float    "median"
    t.float    "coefficient_of_variation"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "cards", :force => true do |t|
    t.integer  "user_id"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.string   "state"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "priority",         :null => false
    t.datetime "state_changed_at"
    t.integer  "user_program_id"
    t.integer  "sender_id"
  end

  add_index "cards", ["user_id", "resource_id", "resource_type"], :name => "index_cards_on_user_id_and_resource_id_and_resource_type"

  create_table "cohorts", :force => true do |t|
    t.datetime "started_at"
    t.datetime "ended_at"
    t.integer  "total_users"
    t.integer  "users_with_message"
    t.integer  "users_with_service"
    t.integer  "converted_users"
    t.text     "raw_data"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "users_with_completed_service"
  end

  create_table "collection_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "communication_workflow_templates", :force => true do |t|
    t.integer  "communication_workflow_id"
    t.integer  "message_template_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "relative_days"
    t.string   "type"
    t.string   "template"
    t.string   "reference_event"
    t.integer  "relative_hours"
  end

  add_index "communication_workflow_templates", ["communication_workflow_id"], :name => "index_communication_workflow_id"

  create_table "communication_workflows", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "conditions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "snomed_name"
    t.string   "snomed_code"
    t.datetime "disabled_at"
    t.string   "concept_id"
    t.string   "description_id"
  end

  create_table "consult_conversation_state_transitions", :force => true do |t|
    t.integer  "consult_id"
    t.string   "event"
    t.string   "from"
    t.string   "to"
    t.datetime "created_at"
  end

  add_index "consult_conversation_state_transitions", ["consult_id"], :name => "index_consult_conversation_state_transitions_on_consult_id"

  create_table "consults", :force => true do |t|
    t.string   "state"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.integer  "subject_id",         :default => 0,     :null => false
    t.integer  "initiator_id",       :default => 0,     :null => false
    t.string   "title"
    t.string   "description"
    t.string   "image"
    t.integer  "symptom_id"
    t.boolean  "master",             :default => false, :null => false
    t.string   "conversation_state"
    t.integer  "delayed_job_id"
    t.datetime "disabled_at"
  end

  add_index "consults", ["initiator_id"], :name => "index_consults_on_initiator_id"
  add_index "consults", ["subject_id"], :name => "index_consults_on_subject_id"
  add_index "consults", ["symptom_id"], :name => "index_consults_on_symptom_id"

  create_table "content_mayo_vocabularies", :force => true do |t|
    t.integer  "content_id"
    t.integer  "mayo_vocabulary_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "content_mayo_vocabularies", ["content_id"], :name => "index_content_mayo_vocabularies_on_content_id"
  add_index "content_mayo_vocabularies", ["mayo_vocabulary_id"], :name => "index_content_mayo_vocabularies_on_mayo_vocabulary_id"

  create_table "content_references", :force => true do |t|
    t.integer  "referrer_id"
    t.integer  "referee_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "content_references", ["referee_id"], :name => "index_content_references_on_referee_id"
  add_index "content_references", ["referrer_id"], :name => "index_content_references_on_referrer_id"

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
    t.boolean  "show_mayo_logo",         :default => true,  :null => false
    t.boolean  "has_custom_card",        :default => false, :null => false
    t.text     "card_actions"
    t.integer  "condition_id"
    t.string   "card_template"
    t.string   "card_abstract"
    t.string   "preview_image_url"
  end

  add_index "contents", ["condition_id"], :name => "index_contents_on_condition_id"
  add_index "contents", ["document_id"], :name => "index_contents_on_document_id"

  create_table "custom_cards", :force => true do |t|
    t.integer  "content_id"
    t.string   "title"
    t.text     "raw_preview"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.text     "card_actions"
    t.text     "timeline_action"
    t.integer  "priority",        :default => 0,     :null => false
    t.string   "unique_id"
    t.boolean  "has_custom_card", :default => false, :null => false
    t.boolean  "payment_card"
    t.boolean  "pha_card"
  end

  add_index "custom_cards", ["content_id"], :name => "index_custom_cards_on_content_id"

  create_table "data_field_changes", :force => true do |t|
    t.integer  "data_field_id"
    t.integer  "actor_id"
    t.text     "data"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "data_field_templates", :force => true do |t|
    t.integer  "service_template_id"
    t.string   "name"
    t.string   "type"
    t.boolean  "required_for_service_start"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "data_fields", :force => true do |t|
    t.integer  "service_id"
    t.integer  "data_field_template_id"
    t.text     "data"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
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

  create_table "discounts", :force => true do |t|
    t.integer  "referral_code_id",                               :null => false
    t.integer  "user_id",                                        :null => false
    t.boolean  "referrer",                                       :null => false
    t.datetime "redeemed_at"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.string   "invoice_item_id"
    t.decimal  "discount_percent", :precision => 2, :scale => 1, :null => false
    t.integer  "referee_id"
  end

  add_index "discounts", ["referral_code_id"], :name => "index_discounts_on_referral_code_id"
  add_index "discounts", ["user_id"], :name => "index_discounts_on_user_id"

  create_table "domains", :force => true do |t|
    t.string   "email_domain"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "emergency_contacts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "designee_id"
    t.string   "name"
    t.string   "phone_number"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "emergency_contacts", ["designee_id"], :name => "index_emergency_contacts_on_designee_id"
  add_index "emergency_contacts", ["user_id"], :name => "index_emergency_contacts_on_user_id"

  create_table "enrollments", :force => true do |t|
    t.string   "token"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "first_name"
    t.string   "last_name"
    t.date     "birth_date"
    t.string   "advertiser_id"
    t.string   "time_zone"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "user_id"
    t.string   "advertiser_media_source"
    t.string   "advertiser_campaign"
    t.string   "code"
    t.integer  "referral_code_id"
    t.integer  "onboarding_group_id"
    t.string   "unique_on_boarding_user_token"
  end

  add_index "enrollments", ["email"], :name => "index_enrollments_on_email"
  add_index "enrollments", ["token"], :name => "index_enrollments_on_token"

  create_table "entries", :force => true do |t|
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "member_id",     :null => false
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "actor_id"
    t.text     "data"
  end

  add_index "entries", ["member_id"], :name => "index_entries_on_member_id"
  add_index "entries", ["resource_id", "resource_type"], :name => "index_entries_on_resource_id_and_resource_type"

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

  add_index "factor_contents", ["content_id"], :name => "index_factor_contents_on_content_id"
  add_index "factor_contents", ["factor_id"], :name => "index_factor_contents_on_factor_id"

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

  add_index "factors", ["factor_group_id"], :name => "index_factors_on_factor_group_id"

  create_table "feature_flag_changes", :force => true do |t|
    t.integer  "feature_flag_id"
    t.integer  "actor_id"
    t.text     "data"
    t.string   "action"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "feature_flag_changes", ["feature_flag_id"], :name => "index_feature_flag_changes_on_feature_flag_id"

  create_table "feature_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.text     "metadata_override"
  end

  create_table "hcp_taxonomies", :force => true do |t|
    t.string   "code"
    t.string   "hcptype"
    t.string   "classification"
    t.string   "specialization"
    t.text     "definition"
    t.text     "notes"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "heights", :force => true do |t|
    t.integer  "user_id"
    t.decimal  "amount",           :precision => 9, :scale => 5
    t.datetime "taken_at"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.string   "healthkit_uuid"
    t.integer  "creator_id"
    t.string   "healthkit_source"
  end

  add_index "heights", ["creator_id"], :name => "index_heights_on_creator_id"
  add_index "heights", ["user_id"], :name => "index_heights_on_user_id"

  create_table "insurance_policies", :force => true do |t|
    t.integer  "user_id"
    t.string   "company_name"
    t.string   "plan_type"
    t.string   "policy_member_id"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.text     "notes"
    t.string   "group_number"
    t.datetime "effective_date"
    t.datetime "termination_date"
    t.string   "member_services_number"
    t.boolean  "authorized",                       :default => false, :null => false
    t.string   "subscriber_name"
    t.string   "plan"
    t.string   "family_individual"
    t.string   "employer_exchange"
    t.integer  "insurance_card_front_id"
    t.integer  "insurance_card_back_id"
    t.string   "insurance_card_front_client_guid"
    t.string   "insurance_card_back_client_guid"
    t.datetime "disabled_at"
  end

  add_index "insurance_policies", ["insurance_card_back_id"], :name => "index_insurance_policies_on_insurance_card_back_id"
  add_index "insurance_policies", ["insurance_card_front_id"], :name => "index_insurance_policies_on_insurance_card_front_id"
  add_index "insurance_policies", ["user_id"], :name => "index_insurance_policies_on_user_id"

  create_table "invitations", :force => true do |t|
    t.integer  "member_id"
    t.integer  "invited_member_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "token"
    t.string   "state"
  end

  add_index "invitations", ["member_id"], :name => "index_invitations_on_member_id"
  add_index "invitations", ["token"], :name => "index_invitations_on_token"

  create_table "mayo_vocabularies", :force => true do |t|
    t.string   "mcvid"
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "member_state_transitions", :force => true do |t|
    t.integer  "member_id"
    t.integer  "actor_id"
    t.string   "event"
    t.string   "from"
    t.string   "to"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.datetime "free_trial_ends_at"
  end

  add_index "member_state_transitions", ["actor_id"], :name => "index_member_state_transitions_on_actor_id"
  add_index "member_state_transitions", ["member_id"], :name => "index_member_state_transitions_on_member_id"

  create_table "message_statuses", :force => true do |t|
    t.integer  "message_id"
    t.integer  "user_id"
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "message_statuses", ["message_id"], :name => "index_message_statuses_on_message_id"
  add_index "message_statuses", ["user_id"], :name => "index_message_statuses_on_user_id"

  create_table "message_templates", :force => true do |t|
    t.string   "name"
    t.text     "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "subject"
    t.integer  "content_id"
  end

  add_index "message_templates", ["content_id"], :name => "index_message_templates_on_content_id"

  create_table "messages", :force => true do |t|
    t.text     "text"
    t.integer  "user_id"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "consult_id"
    t.integer  "content_id"
    t.integer  "scheduled_phone_call_id"
    t.integer  "phone_call_id"
    t.string   "image"
    t.integer  "phone_call_summary_id"
    t.integer  "symptom_id"
    t.integer  "condition_id"
    t.boolean  "cloned"
    t.boolean  "off_hours",               :default => false, :null => false
    t.boolean  "note",                    :default => false, :null => false
    t.integer  "user_image_id"
    t.string   "user_image_client_guid"
    t.boolean  "system"
    t.boolean  "automated",               :default => false, :null => false
    t.integer  "service_id"
  end

  add_index "messages", ["consult_id", "created_at", "note"], :name => "index_messages_on_consult_id_and_created_at_and_note"
  add_index "messages", ["consult_id", "created_at"], :name => "index_messages_on_consult_id_and_created_at"
  add_index "messages", ["content_id"], :name => "index_messages_on_content_id"
  add_index "messages", ["phone_call_id"], :name => "index_messages_on_phone_call_id"
  add_index "messages", ["service_id"], :name => "index_messages_on_service_id"
  add_index "messages", ["user_id"], :name => "index_messages_on_user_id"

  create_table "metadata", :force => true do |t|
    t.string   "mkey",        :null => false
    t.string   "mvalue",      :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "type"
    t.text     "description"
    t.datetime "disabled_at"
  end

  create_table "modal_templates", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "accept"
    t.string   "reject"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "nurseline_records", :force => true do |t|
    t.text     "payload"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "api_user_id"
    t.datetime "disabled_at"
  end

  add_index "nurseline_records", ["api_user_id"], :name => "index_nurseline_records_on_api_user_id"

  create_table "nux_answers", :force => true do |t|
    t.text     "name"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.text     "text"
    t.boolean  "active",     :default => true, :null => false
    t.integer  "ordinal"
    t.text     "phrase"
  end

  create_table "nux_stories", :force => true do |t|
    t.text     "html",                         :limit => 2147483647
    t.string   "action_button_text"
    t.boolean  "show_nav_signup"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.string   "unique_id"
    t.integer  "ordinal"
    t.boolean  "enable_webview_scrolling"
    t.text     "text_header"
    t.text     "text_footer"
    t.boolean  "enabled"
    t.string   "secondary_action_button_text"
  end

  create_table "nux_story_changes", :force => true do |t|
    t.integer  "nux_story_id"
    t.text     "data"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "nux_story_changes", ["nux_story_id"], :name => "index_nux_story_changes_on_nux_story_id"

  create_table "onboarding_group_candidates", :force => true do |t|
    t.integer  "onboarding_group_id"
    t.string   "email"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "user_id"
  end

  create_table "onboarding_group_cards", :force => true do |t|
    t.integer  "onboarding_group_id"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.integer  "priority"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "onboarding_group_cards", ["onboarding_group_id", "resource_id"], :name => "index_onboarding_group_id_resource_id"

  create_table "onboarding_group_programs", :force => true do |t|
    t.integer  "onboarding_group_id"
    t.integer  "program_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "onboarding_group_programs", ["onboarding_group_id"], :name => "index_onboarding_group_programs_on_onboarding_group_id"
  add_index "onboarding_group_programs", ["program_id"], :name => "index_onboarding_group_programs_on_program_id"

  create_table "onboarding_group_suggested_service_templates", :force => true do |t|
    t.integer  "onboarding_group_id"
    t.integer  "suggested_service_template_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "onboarding_groups", :force => true do |t|
    t.string   "name"
    t.boolean  "premium",                       :default => false, :null => false
    t.integer  "free_trial_days",               :default => 0,     :null => false
    t.datetime "absolute_free_trial_ends_at"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.integer  "provider_id"
    t.boolean  "mayo_pilot"
    t.integer  "pha_id"
    t.integer  "trial_nux_story_id"
    t.string   "stripe_coupon_code"
    t.datetime "absolute_subscription_ends_at"
    t.integer  "subscription_days",             :default => 0,     :null => false
    t.boolean  "skip_credit_card",              :default => false, :null => false
    t.boolean  "skip_automated_communications", :default => false, :null => false
    t.boolean  "skip_emails",                   :default => false, :null => false
    t.string   "welcome_email_template"
    t.integer  "welcome_message_template_id"
    t.string   "header_asset"
    t.string   "background_asset"
    t.text     "custom_welcome"
  end

  add_index "onboarding_groups", ["pha_id"], :name => "index_onboarding_groups_on_pha_id"
  add_index "onboarding_groups", ["provider_id"], :name => "index_onboarding_groups_on_provider_id"
  add_index "onboarding_groups", ["trial_nux_story_id"], :name => "index_onboarding_groups_on_trial_nux_story_id"

  create_table "parsed_nurseline_records", :force => true do |t|
    t.integer  "user_id"
    t.integer  "consult_id"
    t.integer  "phone_call_id"
    t.integer  "nurseline_record_id"
    t.text     "text"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "parsed_nurseline_records", ["consult_id"], :name => "index_parsed_nurseline_records_on_consult_id"
  add_index "parsed_nurseline_records", ["nurseline_record_id"], :name => "index_parsed_nurseline_records_on_nurseline_record_id"
  add_index "parsed_nurseline_records", ["phone_call_id"], :name => "index_parsed_nurseline_records_on_phone_call_id"
  add_index "parsed_nurseline_records", ["user_id"], :name => "index_parsed_nurseline_records_on_user_id"

  create_table "permissions", :force => true do |t|
    t.integer  "subject_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "basic_info"
    t.string   "medical_info"
    t.string   "care_team"
  end

  create_table "pha_profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "bio_image"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.text     "bio"
    t.integer  "weekly_capacity"
    t.integer  "capacity_weight"
    t.string   "full_page_bio_image"
    t.integer  "mayo_pilot_capacity_weight"
    t.text     "first_person_bio"
    t.integer  "nux_answer_id"
    t.boolean  "silence_low_welcome_call_email", :default => false, :null => false
  end

  add_index "pha_profiles", ["nux_answer_id"], :name => "index_pha_profiles_on_nux_answer_id"
  add_index "pha_profiles", ["user_id"], :name => "index_pha_profiles_on_user_id"

  create_table "phone_call_summaries", :force => true do |t|
    t.integer  "caller_id",  :null => false
    t.integer  "callee_id",  :null => false
    t.text     "body",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "phone_call_summaries", ["callee_id"], :name => "index_phone_call_summaries_on_callee_id"
  add_index "phone_call_summaries", ["caller_id"], :name => "index_phone_call_summaries_on_caller_id"

  create_table "phone_calls", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.string   "origin_phone_number"
    t.string   "destination_phone_number"
    t.string   "state"
    t.datetime "claimed_at"
    t.datetime "ended_at"
    t.integer  "claimer_id"
    t.integer  "ender_id"
    t.string   "identifier_token"
    t.integer  "to_role_id"
    t.integer  "dialer_id"
    t.datetime "dialed_at"
    t.integer  "resolver"
    t.datetime "resolved_at"
    t.string   "destination_twilio_sid"
    t.string   "origin_twilio_sid"
    t.integer  "transferred_to_phone_call_id"
    t.datetime "missed_at"
    t.string   "twilio_conference_name"
    t.string   "origin_status"
    t.string   "destination_status"
    t.boolean  "outbound",                     :default => false, :null => false
    t.integer  "merged_into_phone_call_id"
    t.integer  "creator_id"
  end

  add_index "phone_calls", ["claimer_id"], :name => "index_phone_calls_on_claimer_id"
  add_index "phone_calls", ["destination_twilio_sid"], :name => "index_phone_calls_on_destination_twilio_sid"
  add_index "phone_calls", ["ender_id"], :name => "index_phone_calls_on_ender_id"
  add_index "phone_calls", ["identifier_token"], :name => "index_phone_calls_on_identifier_token"
  add_index "phone_calls", ["origin_phone_number"], :name => "index_phone_calls_on_origin_phone_number"
  add_index "phone_calls", ["origin_twilio_sid"], :name => "index_phone_calls_on_origin_twilio_sid"
  add_index "phone_calls", ["state", "origin_phone_number"], :name => "index_phone_calls_on_state_and_origin_phone_number"
  add_index "phone_calls", ["state"], :name => "index_phone_calls_on_state"
  add_index "phone_calls", ["to_role_id"], :name => "index_phone_calls_on_to_role_id"

  create_table "phone_numbers", :force => true do |t|
    t.string   "type"
    t.string   "number"
    t.boolean  "primary",        :default => false, :null => false
    t.integer  "phoneable_id"
    t.string   "phoneable_type"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "program_resources", :force => true do |t|
    t.integer  "program_id"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "ordinal"
  end

  add_index "program_resources", ["program_id", "resource_id"], :name => "index_program_id_resource_id_on_program_resources"

  create_table "programs", :force => true do |t|
    t.string   "title",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "provider_call_logs", :force => true do |t|
    t.string   "npi"
    t.integer  "number"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "provider_profiles", :force => true do |t|
    t.string   "npi_number", :limit => 10
    t.string   "first_name"
    t.string   "last_name"
    t.string   "image_url"
    t.string   "gender"
    t.text     "ratings"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "provider_search_preferences", :force => true do |t|
    t.string   "lat"
    t.string   "lon"
    t.decimal  "distance",      :precision => 10, :scale => 0
    t.string   "gender"
    t.string   "specialty_uid"
    t.string   "insurance_uid"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  create_table "provider_search_results", :force => true do |t|
    t.integer  "provider_profile_id"
    t.integer  "provider_search_id"
    t.string   "state"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "provider_searches", :force => true do |t|
    t.integer  "provider_search_preferences_id"
    t.string   "state"
    t.integer  "user_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "providers", :force => true do |t|
    t.integer  "user_id"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "phone"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "providers", ["user_id"], :name => "index_providers_on_user_id"

  create_table "proximities", :force => true do |t|
    t.string   "city"
    t.string   "zip"
    t.string   "state"
    t.string   "county"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "referral_codes", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "creator_id"
    t.integer  "onboarding_group_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "user_id"
  end

  add_index "referral_codes", ["creator_id"], :name => "index_referral_codes_on_creator_id"
  add_index "referral_codes", ["user_id"], :name => "index_referral_codes_on_user_id"

  create_table "remote_events", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.text     "data"
    t.integer  "user_id"
    t.string   "device_id"
  end

  add_index "remote_events", ["user_id"], :name => "index_remote_events_on_user_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "scheduled_communications", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "message_id"
    t.text     "text"
    t.string   "state"
    t.datetime "publish_at"
    t.datetime "delivered_at"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.text     "variables"
    t.string   "type"
    t.integer  "recipient_id"
    t.string   "template"
    t.string   "subject"
    t.integer  "reference_id"
    t.string   "reference_type"
    t.string   "reference_event"
    t.integer  "relative_days"
    t.integer  "content_id"
    t.integer  "delayed_job_id"
    t.integer  "service_id"
  end

  add_index "scheduled_communications", ["recipient_id", "state", "type"], :name => "index_scheduled_communications_recipient_id_state_type"
  add_index "scheduled_communications", ["recipient_id"], :name => "index_scheduled_communications_on_recipient_id"

  create_table "scheduled_phone_calls", :force => true do |t|
    t.integer  "user_id"
    t.integer  "phone_call_id"
    t.datetime "scheduled_at"
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
    t.datetime "disabled_at"
    t.integer  "owner_id"
    t.string   "state",                         :default => "unassigned"
    t.integer  "assignor_id"
    t.datetime "assigned_at"
    t.integer  "booker_id"
    t.datetime "booked_at"
    t.integer  "canceler_id"
    t.datetime "canceled_at"
    t.integer  "ender_id"
    t.datetime "ended_at"
    t.integer  "scheduled_duration_s",          :default => 1800,         :null => false
    t.string   "callback_phone_number"
    t.integer  "reminder_scheduled_message_id"
  end

  add_index "scheduled_phone_calls", ["scheduled_at"], :name => "index_scheduled_phone_calls_on_scheduled_at"
  add_index "scheduled_phone_calls", ["state", "scheduled_at"], :name => "index_scheduled_phone_calls_on_state_and_scheduled_at"
  add_index "scheduled_phone_calls", ["state"], :name => "index_scheduled_phone_calls_on_state"

  create_table "service_changes", :force => true do |t|
    t.integer  "service_id", :null => false
    t.string   "event"
    t.string   "from"
    t.string   "to"
    t.text     "data"
    t.integer  "actor_id",   :null => false
    t.datetime "created_at", :null => false
    t.string   "reason"
  end

  add_index "service_changes", ["service_id"], :name => "index_service_changes_on_service_id"

  create_table "service_state_transitions", :force => true do |t|
    t.integer  "service_id", :null => false
    t.string   "event"
    t.string   "from"
    t.string   "to"
    t.integer  "actor_id",   :null => false
    t.datetime "created_at", :null => false
  end

  add_index "service_state_transitions", ["actor_id"], :name => "index_service_state_transitions_on_actor_id"
  add_index "service_state_transitions", ["service_id"], :name => "index_service_state_transitions_on_service_id"

  create_table "service_templates", :force => true do |t|
    t.string   "name",                               :null => false
    t.string   "title",                              :null => false
    t.text     "description"
    t.integer  "service_type_id",                    :null => false
    t.integer  "time_estimate"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.boolean  "timed_service",   :default => false, :null => false
    t.boolean  "user_facing",     :default => false, :null => false
    t.text     "service_update"
    t.text     "service_request"
    t.string   "unique_id"
    t.integer  "version",         :default => 0,     :null => false
    t.string   "state"
  end

  add_index "service_templates", ["service_type_id"], :name => "index_service_templates_on_service_type_id"

  create_table "service_types", :force => true do |t|
    t.string   "name",                 :null => false
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "bucket"
    t.text     "description_template"
  end

  add_index "service_types", ["bucket"], :name => "index_service_types_on_bucket"
  add_index "service_types", ["name"], :name => "index_service_types_on_name", :unique => true

  create_table "services", :force => true do |t|
    t.string   "title",                                  :null => false
    t.text     "description"
    t.integer  "service_type_id",                        :null => false
    t.string   "state",                                  :null => false
    t.integer  "member_id",                              :null => false
    t.integer  "subject_id"
    t.string   "reason_abandoned"
    t.integer  "creator_id",                             :null => false
    t.integer  "owner_id",                               :null => false
    t.integer  "assignor_id",                            :null => false
    t.datetime "due_at"
    t.datetime "assigned_at"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "service_template_id"
    t.datetime "completed_at"
    t.datetime "abandoned_at"
    t.integer  "abandoner_id"
    t.boolean  "user_facing",         :default => false, :null => false
    t.text     "service_request"
    t.text     "service_deliverable"
    t.text     "service_update"
  end

  add_index "services", ["assignor_id"], :name => "index_services_on_assignor_id"
  add_index "services", ["creator_id"], :name => "index_services_on_creator_id"
  add_index "services", ["member_id"], :name => "index_services_on_member_id"
  add_index "services", ["service_type_id"], :name => "index_services_on_service_type_id"
  add_index "services", ["subject_id"], :name => "index_services_on_subject_id"

  create_table "sessions", :force => true do |t|
    t.integer  "member_id"
    t.string   "auth_token"
    t.string   "device_id"
    t.string   "apns_token"
    t.string   "gcm_id"
    t.string   "device_os"
    t.string   "device_app_version"
    t.string   "device_app_build"
    t.string   "device_timezone"
    t.boolean  "device_notifications_enabled"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "advertiser_id"
    t.datetime "disabled_at"
    t.string   "device_model"
    t.string   "device_os_version"
    t.integer  "logging_level"
    t.integer  "logging_command"
    t.string   "type"
    t.string   "queue_mode"
  end

  add_index "sessions", ["advertiser_id"], :name => "index_sessions_on_advertiser_id"
  add_index "sessions", ["auth_token"], :name => "index_sessions_on_auth_token", :unique => true
  add_index "sessions", ["device_id"], :name => "index_sessions_on_device_id"

  create_table "side_effects", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "subscription_users", :force => true do |t|
    t.integer  "subscription_id"
    t.integer  "user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "subscription_users", ["subscription_id"], :name => "index_subscription_users_on_subscription_id"

  create_table "subscriptions", :force => true do |t|
    t.integer  "owner_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "suggested_service_templates", :force => true do |t|
    t.integer  "service_template_id"
    t.string   "title"
    t.text     "description"
    t.text     "message"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "suggested_services", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "suggested_service_template_id"
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

  create_table "system_event_templates", :force => true do |t|
    t.string   "name",                       :null => false
    t.string   "title",                      :null => false
    t.text     "description"
    t.string   "unique_id",                  :null => false
    t.integer  "version",     :default => 0, :null => false
    t.string   "state"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "task_changes", :force => true do |t|
    t.integer  "task_id",    :null => false
    t.string   "event"
    t.string   "from"
    t.string   "to"
    t.text     "data"
    t.integer  "actor_id",   :null => false
    t.datetime "created_at", :null => false
    t.string   "reason"
  end

  add_index "task_changes", ["task_id"], :name => "index_task_changes_on_task_id"

  create_table "task_data_field_templates", :force => true do |t|
    t.integer  "task_template_id"
    t.integer  "data_field_template_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "type"
  end

  create_table "task_data_fields", :force => true do |t|
    t.integer  "task_id"
    t.integer  "data_field_id"
    t.integer  "task_data_field_template_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.string   "type"
  end

  create_table "task_step_changes", :force => true do |t|
    t.integer  "task_step_id"
    t.integer  "actor_id"
    t.text     "data"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "task_step_data_field_templates", :force => true do |t|
    t.integer  "task_step_template_id"
    t.integer  "task_data_field_template_id"
    t.integer  "ordinal"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "required_for_task_step_completion"
  end

  create_table "task_step_data_fields", :force => true do |t|
    t.integer  "task_step_id"
    t.integer  "task_data_field_id"
    t.integer  "task_step_data_field_template_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "task_step_templates", :force => true do |t|
    t.integer  "task_template_id"
    t.text     "description"
    t.integer  "ordinal"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.text     "details"
    t.text     "template"
  end

  create_table "task_steps", :force => true do |t|
    t.integer  "task_id"
    t.integer  "task_step_template_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.datetime "completed_at"
  end

  create_table "task_templates", :force => true do |t|
    t.string   "name",                :null => false
    t.string   "title",               :null => false
    t.text     "description"
    t.integer  "time_estimate"
    t.integer  "service_ordinal"
    t.integer  "service_template_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "priority"
    t.integer  "modal_template_id"
  end

  add_index "task_templates", ["service_template_id"], :name => "index_task_templates_on_service_template_id"

  create_table "tasks", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "role_id"
    t.integer  "owner_id"
    t.integer  "member_id"
    t.integer  "subject_id"
    t.integer  "assignor_id"
    t.integer  "consult_id"
    t.integer  "phone_call_id"
    t.integer  "scheduled_phone_call_id"
    t.integer  "message_id"
    t.integer  "phone_call_summary_id"
    t.datetime "due_at"
    t.datetime "assigned_at"
    t.datetime "claimed_at"
    t.datetime "completed_at"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.integer  "creator_id"
    t.string   "state"
    t.integer  "abandoner_id"
    t.datetime "abandoned_at"
    t.string   "reason_abandoned"
    t.string   "type"
    t.integer  "parsed_nurseline_record_id"
    t.integer  "service_type_id"
    t.integer  "priority"
    t.integer  "service_id"
    t.integer  "service_ordinal"
    t.integer  "task_template_id"
    t.integer  "user_request_id"
    t.datetime "member_free_trial_ends_at"
    t.integer  "delayed_job_id"
    t.integer  "day_priority",               :default => 0,     :null => false
    t.boolean  "visible_in_queue",           :default => true,  :null => false
    t.integer  "time_estimate"
    t.boolean  "urgent",                     :default => false, :null => false
    t.boolean  "unread",                     :default => false, :null => false
    t.boolean  "follow_up",                  :default => false, :null => false
    t.datetime "unclaimed_at"
    t.datetime "blocked_internal_at"
    t.datetime "blocked_external_at"
    t.datetime "unblocked_at"
    t.string   "queue"
  end

  add_index "tasks", ["owner_id", "state", "role_id", "type"], :name => "queue_test"
  add_index "tasks", ["owner_id", "state"], :name => "index_tasks_on_owner_id_and_state"
  add_index "tasks", ["state", "due_at", "created_at"], :name => "index_tasks_on_state_and_due_at_and_created_at"
  add_index "tasks", ["state"], :name => "index_tasks_on_state"
  add_index "tasks", ["type", "consult_id", "state"], :name => "index_tasks_on_type_and_consult_id_and_state"

  create_table "treatment_side_effects", :force => true do |t|
    t.integer  "treatment_id"
    t.integer  "side_effect_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "treatment_side_effects", ["treatment_id"], :name => "index_treatment_side_effects_on_treatment_id"

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

  add_index "user_agreements", ["user_id", "agreement_id"], :name => "index_user_agreements_on_user_id_and_agreement_id"

  create_table "user_allergies", :force => true do |t|
    t.integer  "user_id"
    t.integer  "allergy_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_allergies", ["allergy_id"], :name => "index_user_allergies_on_allergy_id"
  add_index "user_allergies", ["user_id"], :name => "index_user_allergies_on_user_id"

  create_table "user_changes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "actor_id"
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "action"
  end

  add_index "user_changes", ["actor_id"], :name => "index_user_changes_on_actor_id"
  add_index "user_changes", ["user_id"], :name => "index_user_changes_on_user_id"

  create_table "user_condition_user_treatments", :force => true do |t|
    t.integer  "user_condition_id", :null => false
    t.integer  "user_treatment_id", :null => false
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "user_condition_user_treatments", ["user_condition_id"], :name => "index_user_condition_user_treatments_on_user_condition_id"
  add_index "user_condition_user_treatments", ["user_treatment_id"], :name => "index_user_condition_user_treatments_on_user_treatment_id"

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

  add_index "user_conditions", ["condition_id"], :name => "index_user_conditions_on_condition_id"
  add_index "user_conditions", ["diagnoser_id"], :name => "index_user_conditions_on_diagnoser_id"
  add_index "user_conditions", ["user_id"], :name => "index_user_conditions_on_user_id"

  create_table "user_content_likes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "content_id"
    t.string   "action"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_content_likes", ["content_id"], :name => "index_user_content_likes_on_content_id"
  add_index "user_content_likes", ["user_id"], :name => "index_user_content_likes_on_user_id"

  create_table "user_feature_groups", :force => true do |t|
    t.integer  "user_id"
    t.integer  "feature_group_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "user_feature_groups", ["feature_group_id"], :name => "index_user_feature_groups_on_feature_group_id"
  add_index "user_feature_groups", ["user_id"], :name => "index_user_feature_groups_on_user_id"

  create_table "user_images", :force => true do |t|
    t.integer  "user_id"
    t.string   "image"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "client_guid"
  end

  add_index "user_images", ["user_id"], :name => "index_user_images_on_user_id"

  create_table "user_informations", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.text     "notes"
    t.text     "highlights"
  end

  add_index "user_informations", ["user_id"], :name => "index_user_informations_on_user_id"

  create_table "user_programs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "program_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "subject_id"
  end

  add_index "user_programs", ["program_id"], :name => "index_user_programs_on_program_id"
  add_index "user_programs", ["subject_id"], :name => "index_user_programs_on_subject_id"
  add_index "user_programs", ["user_id"], :name => "index_user_programs_on_user_id"

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

  add_index "user_readings", ["user_id", "content_id"], :name => "index_user_readings_on_user_id_and_content_id"

  create_table "user_request_type_fields", :force => true do |t|
    t.integer  "user_request_type_id"
    t.string   "name"
    t.string   "type"
    t.integer  "ordinal"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "user_request_type_fields", ["user_request_type_id"], :name => "index_user_request_type_fields_on_user_request_type_id"

  create_table "user_request_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_requests", :force => true do |t|
    t.integer  "user_id"
    t.integer  "subject_id"
    t.string   "name"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "user_request_type_id"
    t.text     "request_data"
  end

  add_index "user_requests", ["subject_id"], :name => "index_user_requests_on_subject_id"
  add_index "user_requests", ["user_id"], :name => "index_user_requests_on_user_id"
  add_index "user_requests", ["user_request_type_id"], :name => "index_user_requests_on_user_request_type_id"

  create_table "user_roles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_roles", ["role_id"], :name => "index_user_roles_on_role_id"
  add_index "user_roles", ["user_id"], :name => "index_user_roles_on_user_id"

  create_table "user_treatment_side_effects", :force => true do |t|
    t.integer  "user_treatment_id"
    t.integer  "side_effect_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "user_treatment_side_effects", ["side_effect_id"], :name => "index_user_treatment_side_effects_on_side_effect_id"
  add_index "user_treatment_side_effects", ["user_treatment_id"], :name => "index_user_treatment_side_effects_on_user_treatment_id"

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

  add_index "user_treatments", ["doctor_id"], :name => "index_user_treatments_on_doctor_id"
  add_index "user_treatments", ["treatment_id"], :name => "index_user_treatments_on_treatment_id"
  add_index "user_treatments", ["user_id"], :name => "index_user_treatments_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.date     "birth_date"
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
    t.string   "avatar"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer  "ethnic_group_id"
    t.integer  "diet_id"
    t.string   "blood_type"
    t.string   "npi_number",                      :limit => 10
    t.date     "date_of_death"
    t.string   "expertise"
    t.boolean  "deceased",                                      :default => false, :null => false
    t.string   "type",                                          :default => "",    :null => false
    t.string   "invitation_token"
    t.string   "units",                                         :default => "US",  :null => false
    t.string   "stripe_customer_id"
    t.string   "google_analytics_uuid",           :limit => 36
    t.string   "avatar_url_override"
    t.text     "client_data"
    t.string   "nickname"
    t.integer  "default_hcp_association_id"
    t.boolean  "member_flag"
    t.string   "provider_taxonomy_code"
    t.integer  "owner_id"
    t.integer  "pha_id"
    t.datetime "free_trial_ends_at"
    t.datetime "last_contact_at"
    t.datetime "signed_up_at"
    t.datetime "subscription_ends_at"
    t.integer  "onboarding_group_id"
    t.integer  "referral_code_id"
    t.boolean  "on_call",                                       :default => false
    t.string   "status"
    t.integer  "nux_answer_id"
    t.string   "time_zone"
    t.boolean  "cached_notifications_enabled"
    t.boolean  "email_confirmed"
    t.string   "email_confirmation_token"
    t.date     "due_date"
    t.string   "advertiser_id"
    t.string   "advertiser_media_source"
    t.string   "advertiser_campaign"
    t.integer  "impersonated_user_id"
    t.integer  "coupon_count",                                  :default => 0,     :null => false
    t.string   "unique_on_boarding_user_token"
    t.boolean  "delinquent"
    t.string   "kinsights_token"
    t.string   "kinsights_patient_url"
    t.string   "kinsights_profile_url"
  end

  add_index "users", ["email", "member_flag"], :name => "index_users_on_email_and_member_flag", :unique => true
  add_index "users", ["email_confirmation_token"], :name => "index_users_on_email_confirmation_token"
  add_index "users", ["onboarding_group_id"], :name => "index_users_on_onboarding_group_id"
  add_index "users", ["pha_id"], :name => "index_users_on_pha_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token"
  add_index "users", ["type", "last_contact_at"], :name => "index_users_on_type_and_last_contact_at"
  add_index "users", ["type", "pha_id", "last_contact_at"], :name => "index_users_on_type_and_pha_id_and_last_contact_at"
  add_index "users", ["type", "signed_up_at"], :name => "index_users_on_type_and_signed_up_at"

  create_table "weights", :force => true do |t|
    t.integer  "user_id"
    t.decimal  "amount",           :precision => 9, :scale => 5, :default => 0.0
    t.decimal  "bmi",              :precision => 8, :scale => 5
    t.datetime "created_at",                                                      :null => false
    t.datetime "updated_at",                                                      :null => false
    t.datetime "taken_at"
    t.string   "healthkit_uuid"
    t.integer  "creator_id"
    t.string   "healthkit_source"
    t.string   "bmi_level"
  end

  add_index "weights", ["creator_id"], :name => "index_weights_on_creator_id"
  add_index "weights", ["user_id"], :name => "index_weights_on_user_id"

end
