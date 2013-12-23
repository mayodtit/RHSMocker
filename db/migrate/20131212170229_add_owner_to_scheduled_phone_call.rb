class AddOwnerToScheduledPhoneCall < ActiveRecord::Migration
  def change
    add_column :scheduled_phone_calls, :owner_id, :integer
  end
end
