class AddActorIdToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :actor_id, :integer
  end
end
