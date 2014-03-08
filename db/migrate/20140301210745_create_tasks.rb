class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description

      t.references :role
      t.references :owner
      t.references :member
      t.references :subject
      t.references :assignor

      t.references :consult
      t.references :phone_call
      t.references :scheduled_phone_call
      t.references :message
      t.references :phone_call_summary

      t.timestamp :due_at
      t.timestamp :assigned_at
      t.timestamp :started_at
      t.timestamp :claimed_at
      t.timestamp :completed_at

      t.timestamps
    end
  end
end
