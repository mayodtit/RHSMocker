class CreateConsultConversationStateTransitions < ActiveRecord::Migration
  def change
    create_table :consult_conversation_state_transitions do |t|
      t.references :consult
      t.string :event
      t.string :from
      t.string :to
      t.timestamp :created_at
    end
    add_index :consult_conversation_state_transitions, :consult_id
  end
end
