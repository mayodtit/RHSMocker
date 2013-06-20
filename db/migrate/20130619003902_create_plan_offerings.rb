class CreatePlanOfferings < ActiveRecord::Migration
  def change
    create_table :plan_offerings do |t|
      t.references :plan
      t.references :offering
      t.integer :amount
      t.boolean :unlimited

      t.timestamps
    end
    add_index :plan_offerings, :plan_id
    add_index :plan_offerings, :offering_id
  end
end
