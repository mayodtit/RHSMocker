class CreateServiceStateTransitions < ActiveRecord::Migration
  def change
    create_table :service_state_transitions do |t|
      t.references :service, null: false
      t.string :event
      t.string :from
      t.string :to
      t.references :actor, null: false
      t.timestamp :created_at, null: false
    end
    add_index :service_state_transitions, :service_id
  end
end
