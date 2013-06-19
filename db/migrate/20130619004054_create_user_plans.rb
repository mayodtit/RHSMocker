class CreateUserPlans < ActiveRecord::Migration
  def change
    create_table :user_plans do |t|
      t.references :plan
      t.references :user

      t.timestamps
    end
    add_index :user_plans, :plan_id
    add_index :user_plans, :user_id
  end
end
