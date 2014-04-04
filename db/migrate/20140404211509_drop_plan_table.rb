class DropPlanTable < ActiveRecord::Migration
  def up
    drop_table :plans
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
