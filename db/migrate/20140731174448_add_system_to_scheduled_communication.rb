class AddSystemToScheduledCommunication < ActiveRecord::Migration
  def change
    add_column :scheduled_communications, :system_message, :boolean
  end
end
