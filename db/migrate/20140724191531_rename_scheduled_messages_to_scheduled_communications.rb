class RenameScheduledMessagesToScheduledCommunications < ActiveRecord::Migration
  def up
    rename_table :scheduled_messages, :scheduled_communications
  end

  def down
    rename_table :scheduled_communications, :scheduled_messages
  end
end
