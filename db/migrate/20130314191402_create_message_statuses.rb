class CreateMessageStatuses < ActiveRecord::Migration
  def change
    create_table :message_statuses do |t|
      t.references :message
      t.references :user
      t.string :status

      t.timestamps
    end
    add_index :message_statuses, :message_id
    add_index :message_statuses, :user_id
  end
end
