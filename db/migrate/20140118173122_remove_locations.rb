class RemoveLocations < ActiveRecord::Migration
  def up
    drop_table :locations
    remove_column :messages, :location_id
  end

  def down
    create_table "locations", :force => true do |t|
      t.integer  "user_id"
      t.decimal  "latitude",   :precision => 10, :scale => 6
      t.decimal  "longitude",  :precision => 10, :scale => 6
      t.datetime "created_at",                                :null => false
      t.datetime "updated_at",                                :null => false
    end
    add_column :messages, :location_id, :integer
  end
end
