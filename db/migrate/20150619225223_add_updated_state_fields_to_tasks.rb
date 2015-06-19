class AddUpdatedStateFieldsToTasks < ActiveRecord::Migration
  def up
    remove_column :tasks, :started_at
    add_column :tasks, :unclaimed_at, :datetime
    add_column :tasks, :blocked_internal_at, :datetime
    add_column :tasks, :blocked_external_at, :datetime
    add_column :tasks, :unblocked_at, :datetime
  end

  def down
    remove_column :tasks, :unclaimed_at, :datetime
    remove_column :tasks, :blocked_internal_at, :datetime
    remove_column :tasks, :blocked_external_at, :datetime
    remove_column :tasks, :unblocked_at, :datetime
    add_column :tasks, :started_at, :datetime
  end
end
