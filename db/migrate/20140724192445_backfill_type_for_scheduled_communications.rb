class BackfillTypeForScheduledCommunications < ActiveRecord::Migration
  def up
    ScheduledCommunication.reset_column_information
    ScheduledCommunication.update_all(type: 'ScheduledMessage')
  end

  def down
  end
end
