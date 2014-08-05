class AddMemberFreeTrialEndsAtToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :member_free_trial_ends_at, :datetime
  end
end
