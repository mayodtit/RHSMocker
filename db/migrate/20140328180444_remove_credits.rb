class RemoveCredits < ActiveRecord::Migration
  def up
    drop_table :credits
  end

  def down
    create_table "credits", :force => true do |t|
      t.integer  "offering_id"
      t.integer  "user_id"
      t.datetime "created_at",                     :null => false
      t.datetime "updated_at",                     :null => false
      t.boolean  "unlimited",   :default => false, :null => false
    end
  end
end
