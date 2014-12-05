class AddActorIdToAssociations < ActiveRecord::Migration
  def change
    add_column :associations, :actor_id, :integer
  end
end
