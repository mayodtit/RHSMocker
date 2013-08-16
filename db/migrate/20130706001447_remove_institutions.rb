class RemoveInstitutions < ActiveRecord::Migration
  def up
    drop_table :institutions
    drop_table :institutions_users
  end

  def down
    create_table "institutions", :force => true do |t|
      t.string   "name"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    create_table "institutions_users", :force => true do |t|
      t.integer  "institution_id"
      t.integer  "user_id"
      t.datetime "created_at",     :null => false
      t.datetime "updated_at",     :null => false
    end
  end
end
