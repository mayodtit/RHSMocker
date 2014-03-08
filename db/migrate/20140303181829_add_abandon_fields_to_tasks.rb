class AddAbandonFieldsToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :abandoner_id, :integer
    add_column :tasks, :abandoned_at, :timestamp
    add_column :tasks, :reason_abandoned, :string
  end
end
