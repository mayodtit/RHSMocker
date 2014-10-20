class AddIndexToScheduledCommunications < ActiveRecord::Migration
  def change
    add_index :scheduled_communications, :recipient_id
    add_index :scheduled_communications, %i(recipient_id state type), name: 'index_scheduled_communications_recipient_id_state_type'
  end
end
