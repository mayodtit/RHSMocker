class AddCreatorIdToAssociation < ActiveRecord::Migration
  def change
    add_column :associations, :creator_id, :integer
  end
end
