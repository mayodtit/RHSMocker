class RemoveMonthlyFromPlan < ActiveRecord::Migration
  def up
    remove_column :plans, :monthly
  end

  def down
    add_column :plans, :monthly, :boolean
  end
end
