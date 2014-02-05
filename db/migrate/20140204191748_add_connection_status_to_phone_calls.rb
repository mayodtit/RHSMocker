class AddConnectionStatusToPhoneCalls < ActiveRecord::Migration
  def change
    add_column :phone_calls, :origin_status, :string
    add_column :phone_calls, :destination_status, :string
  end
end
