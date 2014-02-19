class RemoveTypeFromAssociation < ActiveRecord::Migration
  def up
    remove_column :associations, :type
  end

  def down
    add_column :associations, :type, :string
  end
end
