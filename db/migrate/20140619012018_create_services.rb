class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :title, null: false
      t.string :description
      t.integer :service_type_id, null: false
      t.string :state, null: false
      t.integer :member_id, null: false
      t.integer :subject_id
      t.string :reason_abandoned

      t.integer :creator_id, null: false
      t.integer :owner_id, null: false
      t.integer :assignor_id, null: false

      t.datetime :due_at
      t.datetime :assigned_at
      t.timestamps
    end
  end
end
