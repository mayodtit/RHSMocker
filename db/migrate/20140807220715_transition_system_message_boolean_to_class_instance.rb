class TransitionSystemMessageBooleanToClassInstance < ActiveRecord::Migration
  def up
    ScheduledCommunication.where(system_message: true).update_all(type: 'ScheduledSystemMessage')
  end

  def down
  end
end
