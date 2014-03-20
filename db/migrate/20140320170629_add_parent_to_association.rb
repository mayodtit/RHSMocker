class AddParentToAssociation < ActiveRecord::Migration
  def change
    add_column :associations, :parent_id, :integer
  end
end
