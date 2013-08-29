class RemoveFeedbacks < ActiveRecord::Migration
  def up
    drop_table :feedbacks
  end

  def down
    create_table "feedbacks", :force => true do |t|
      t.integer  "user_id"
      t.text     "note"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
  end
end
