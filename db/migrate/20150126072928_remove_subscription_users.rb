class RemoveSubscriptionUsers < ActiveRecord::Migration
  def up
    drop_table :subscription_users
  end

  def down
    create_table "subscription_users", :force => true do |t|
      t.integer  "subscription_id"
      t.integer  "user_id"
      t.datetime "created_at",      :null => false
      t.datetime "updated_at",      :null => false
    end
  end
end
