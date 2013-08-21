class CreateScheduledPhoneCalls < ActiveRecord::Migration
  def change
    create_table :scheduled_phone_calls do |t|
      t.references :user
      t.references :phone_call
      t.timestamp :scheduled_at
      t.timestamps
    end
    add_column :messages, :scheduled_phone_call_id, :integer
  end
end
