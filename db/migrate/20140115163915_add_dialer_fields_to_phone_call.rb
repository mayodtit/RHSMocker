class AddDialerFieldsToPhoneCall < ActiveRecord::Migration
  def change
    add_column :phone_calls, :dialer_id, :integer
    add_column :phone_calls, :dialed_at, :datetime
  end
end
