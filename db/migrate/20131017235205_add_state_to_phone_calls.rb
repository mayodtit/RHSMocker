class AddStateToPhoneCalls < ActiveRecord::Migration
  def change
    add_column :phone_calls, :state, :string
    add_index :phone_calls, :state
    add_column :phone_calls, :claimed_at, :datetime
    add_column :phone_calls, :ended_at, :datetime
    add_column :phone_calls, :claimer_id, :integer
    add_index :phone_calls, :claimer_id
    add_column :phone_calls, :ender_id, :integer
    add_index :phone_calls, :ender_id
  end
end
