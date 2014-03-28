class RemovePlanOffering < ActiveRecord::Migration
  def up
    drop_table :plan_offerings
  end

  def down
    create_table "plan_offerings", :force => true do |t|
      t.integer  "plan_id"
      t.integer  "offering_id"
      t.integer  "amount"
      t.boolean  "unlimited"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end

    add_index "plan_offerings", "offering_id"
    add_index "plan_offerings", "plan_id"
  end
end
