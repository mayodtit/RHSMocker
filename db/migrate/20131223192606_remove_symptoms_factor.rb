class RemoveSymptomsFactor < ActiveRecord::Migration
  def up
    drop_table :symptoms_factors
  end

  def down
    create_table "symptoms_factors", :force => true do |t|
      t.boolean  "doctor_call_worthy"
      t.boolean  "er_worthy"
      t.integer  "symptom_id"
      t.integer  "factor_id"
      t.integer  "factor_group_id"
      t.datetime "created_at",         :null => false
      t.datetime "updated_at",         :null => false
    end

    add_index "symptoms_factors", "factor_group_id"
    add_index "symptoms_factors", "factor_id"
    add_index "symptoms_factors", "symptom_id"
  end
end
