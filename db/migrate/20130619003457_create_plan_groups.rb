class CreatePlanGroups < ActiveRecord::Migration
  def change
    create_table :plan_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
