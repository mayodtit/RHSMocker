class AddResolverAndResolvedAtToPhoneCalls < ActiveRecord::Migration
  def change
    add_column :phone_calls, :resolver, :integer
    add_column :phone_calls, :resolved_at, :datetime
  end
end
