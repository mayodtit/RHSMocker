class AddInitiatorIdToEncounter < ActiveRecord::Migration
  def change
    add_column :encounters, :initiator_id, :integer, :null => false, :default => 0
  end
end
