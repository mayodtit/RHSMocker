class AddAutomatedToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :automated, :boolean, default: false, null: false
  end
end
