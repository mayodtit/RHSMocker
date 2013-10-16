class RemoveAttachments < ActiveRecord::Migration
  def up
    drop_table :attachments
  end

  def down
    create_table "attachments", :force => true do |t|
      t.string   "url"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
      t.integer  "message_id"
    end

    add_index :attachments, :message_id
  end
end
