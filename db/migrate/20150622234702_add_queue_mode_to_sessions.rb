class AddQueueModeToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :queue_mode, :string
  end
end
