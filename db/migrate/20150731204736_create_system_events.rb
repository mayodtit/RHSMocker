class CreateSystemEvents < ActiveRecord::Migration
  def change
    create_table :system_events do |t|
      t.references :user
      t.references :system_event_template
      t.timestamp :trigger_at
      t.string :state
      t.timestamps
    end
  end
end
