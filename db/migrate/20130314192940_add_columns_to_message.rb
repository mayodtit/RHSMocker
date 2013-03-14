class AddColumnsToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :user_location_id, :integer
    add_column :messages, :encounter_id, :integer
  end
end
