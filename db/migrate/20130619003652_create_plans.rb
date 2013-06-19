class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.references :plan_group
      t.boolean :monthly

      t.timestamps
    end
    add_index :plans, :plan_group_id
  end
end
