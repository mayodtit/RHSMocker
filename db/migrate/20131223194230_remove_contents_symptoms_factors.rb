class RemoveContentsSymptomsFactors < ActiveRecord::Migration
  def up
    drop_table :contents_symptoms_factors
  end

  def down
    create_table "contents_symptoms_factors", :force => true do |t|
      t.integer  "content_id"
      t.integer  "symptoms_factor_id"
      t.datetime "created_at",         :null => false
      t.datetime "updated_at",         :null => false
    end

    add_index "contents_symptoms_factors", "content_id"
    add_index "contents_symptoms_factors", "symptoms_factor_id"
  end
end
