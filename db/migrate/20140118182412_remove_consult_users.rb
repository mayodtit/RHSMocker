class RemoveConsultUsers < ActiveRecord::Migration
  def up
    drop_table :consult_users
  end

  def down
    create_table "consult_users", :force => true do |t|
      t.string   "role"
      t.integer  "consult_id"
      t.integer  "user_id"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
  end
end
