class AddVariablesToScheduledMessage < ActiveRecord::Migration
  def change
    add_column :scheduled_messages, :variables, :text
  end
end
