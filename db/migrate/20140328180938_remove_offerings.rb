class RemoveOfferings < ActiveRecord::Migration
  def up
    drop_table :offerings
  end

  def down
    create_table "offerings", :force => true do |t|
      t.string   "name"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
  end
end
