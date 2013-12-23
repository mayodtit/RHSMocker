class AddStateToScheduledPhoneCalls < ActiveRecord::Migration
  def change
    add_column :scheduled_phone_calls, :state, :string, :default => 'unclaimed'
  end
end
