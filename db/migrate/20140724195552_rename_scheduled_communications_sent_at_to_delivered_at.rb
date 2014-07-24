class RenameScheduledCommunicationsSentAtToDeliveredAt < ActiveRecord::Migration
  def up
    rename_column :scheduled_communications, :sent_at, :delivered_at
  end

  def down
    rename_column :scheduled_communications, :delivered_at, :sent_at
  end
end
