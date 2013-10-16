class RemovePlanGroups < ActiveRecord::Migration
  def up
    drop_table :plan_groups
  end

  def down
    create_table "plan_groups", :force => true do |t|
      t.string   "name"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
  end
end
