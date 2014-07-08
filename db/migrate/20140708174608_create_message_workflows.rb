class CreateMessageWorkflows < ActiveRecord::Migration
  def change
    create_table :message_workflows do |t|
      t.string :name
      t.timestamps
    end
  end
end
