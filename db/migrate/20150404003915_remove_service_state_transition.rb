class RemoveServiceStateTransition < ActiveRecord::Migration
  def up
    drop_table :service_state_transitions
  end

  def down
    create_table "service_state_transitions", :force => true do |t|
      t.integer  "service_id", :null => false
      t.string   "event"
      t.string   "from"
      t.string   "to"
      t.integer  "actor_id",   :null => false
      t.datetime "created_at", :null => false
    end

    add_index "service_state_transitions", ["actor_id"], :name => "index_service_state_transitions_on_actor_id"
    add_index "service_state_transitions", ["service_id"], :name => "index_service_state_transitions_on_service_id"
  end
end
