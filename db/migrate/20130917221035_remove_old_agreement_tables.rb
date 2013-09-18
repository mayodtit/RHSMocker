class RemoveOldAgreementTables < ActiveRecord::Migration
  def up
    drop_table :agreement_pages
    drop_table :agreements
  end

  def down
    create_table "agreement_pages", :force => true do |t|
      t.text     "content"
      t.string   "page_type"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    create_table "agreements", :force => true do |t|
      t.string   "ip_address"
      t.string   "user_agent"
      t.integer  "agreement_page_id"
      t.integer  "user_id"
      t.datetime "created_at",        :null => false
      t.datetime "updated_at",        :null => false
    end

    add_index :agreements, :agreement_page_id
    add_index :agreements, :user_id
  end
end
