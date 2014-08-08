class RemoveSystemMessageFromScheduledCommunications < ActiveRecord::Migration
  def up
    remove_column :scheduled_communications, :system_message
  end

  def down
    add_column :scheduled_communications, :system_message, :boolean
  end
end
