class RemoveOldPhoneCall < ActiveRecord::Migration
  def up
    drop_table :phone_calls
    remove_column :user_offerings, :phone_call_id
  end

  def down
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
      t.boolean  "complete"
    end
    add_column :user_offerings, :phone_call_id, :integer
  end
end
