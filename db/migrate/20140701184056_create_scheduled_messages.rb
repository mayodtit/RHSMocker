class CreateScheduledMessages < ActiveRecord::Migration
  def change
    create_table :scheduled_messages do |t|
      t.references :sender
      t.references :consult
      t.references :message
      t.text :text
      t.string :state
      t.timestamp :publish_at
      t.timestamp :sent_at
      t.timestamps
    end
  end
end
