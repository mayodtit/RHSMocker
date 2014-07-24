class UpdateScheduledCommunicationsInSentState < ActiveRecord::Migration
  def up
    ScheduledCommunication.reset_column_information
    ScheduledCommunication.where(state: :sent).update_all(state: :delivered)
  end

  def down
  end
end
