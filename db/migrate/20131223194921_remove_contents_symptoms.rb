class RemoveContentsSymptoms < ActiveRecord::Migration
  def up
    drop_table :contents_symptoms
  end

  def down
    create_table "contents_symptoms", :force => true do |t|
      t.integer  "content_id"
      t.integer  "symptom_id"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    add_index "contents_symptoms", "content_id"
    add_index "contents_symptoms", "symptom_id"
  end
end
