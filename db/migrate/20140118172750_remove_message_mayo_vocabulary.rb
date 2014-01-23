class RemoveMessageMayoVocabulary < ActiveRecord::Migration
  def up
    drop_table :message_mayo_vocabularies
  end

  def down
    create_table "message_mayo_vocabularies", :force => true do |t|
      t.integer  "mayo_vocabulary_id"
      t.integer  "message_id"
      t.datetime "created_at",         :null => false
      t.datetime "updated_at",         :null => false
    end
  end
end
