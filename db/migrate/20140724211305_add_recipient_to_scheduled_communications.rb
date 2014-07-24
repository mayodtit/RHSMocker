class AddRecipientToScheduledCommunications < ActiveRecord::Migration
  def change
    add_column :scheduled_communications, :recipient_id, :integer
  end
end
