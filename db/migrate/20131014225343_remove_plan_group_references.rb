class RemovePlanGroupReferences < ActiveRecord::Migration
  def up
    remove_column :plans, :plan_group_id
  end

  def down
    add_column :plans, :plan_group_id, :integer
    add_index :plans, :plan_group_id
  end
end
